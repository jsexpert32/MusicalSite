class SessionsController < ApplicationController
  include SessionParams
  skip_before_filter :verify_authenticity_token
  skip_before_filter :check_valid_user

  def new
    @user_session = Session.new
  end

  def create
    @user_session = Session.new(params[:session])
    if @user_session.valid?
      sign_in(@user_session.user)
    else
      render :new
    end
  end

  def profile; end

  def destroy
    reset_session
    cookies[:auth_token] = cookies.permanent[:auth_token] = nil
    redirect_to root_url, notice: 'Logged out!'
  end

  def soundcloud
    if params[:code]
      update_sound
      redirect_to new_track_path
    else
      redirect_to Sound.new(auth_callbacks_url(:soundcloud)).client.authorize_url
    end
  end

  def callback
    return redirect_to root_path if params[:error]
    if current_user
      update_sound
      redirect_to soundcloud_tracks_path
    else
      params[:provider] == 'twitter' ? twitter_callback : sound_callback
    end
  end

  private

  def sound_callback
    user = User.fetch_identity(sc_identity_params, remove_empty_values(sc_user_params))
    sign_in(user)
    redirect_to home_index_path(user.id, profile: ('soundcloud' if user.invalid?))
  end

  def twitter_callback
    user = User.fetch_identity(twitter_identity_params, remove_empty_values(twitter_user_params))
    sign_in(user)
    redirect_to home_index_path(user.id, profile: ('twitter' if user.invalid?))
  end

  def update_sound
    identity = current_user.identities.find_or_initialize_by(provider: 'soundcloud')
    identity.update!(sc_identity_params)
  end
end
