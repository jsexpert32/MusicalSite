class ProfilesController < ApplicationController
  before_action :require_guest
  skip_before_filter :check_valid_user

  def show
    current_user.valid? if params[:invalid]
  end

  def update
    if current_user.update(profile_params)
      flash[:notice] = 'Saved successfully'
      redirect_to profile_path
    else
      render :show
    end
  end

  def profile_params
    params.require(:user).permit(:avatar, :first_name, :last_name, :email, :description, :country,
                                 :username, :city, :password, :password_confirmation)
  end
end
