# Step 1: On email enter, create incomplete User and "applied" Tester in
# prefinery API.

# Step 2: Catch tester created webhook, send confirmation email with link.

# Step 3: When arrive to linked action, set User.identity based on Prefinery info.
# Set "tester" on prefinery to 'active'. Show email confirm template.

# Step 4: When an email is submitted, check to make sure its not pre-existing.

class WaitlistsController < ApplicationController
  layout 'no_nav'
  include Waitlist

  def index
    @total = Prefinery.total_waiting
    session[:referrer_id] = params[:referrer_id] if params[:referrer_id]
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.current_tester?
      redirect_to :root, notice: 'Looks like we already have your email.'
    else
      prefinery_tester
      render json: { success: 'success', url: waitlists_email_confirm_path }
    end
  end

  def update
    user      = User.find_by(token: params[:token])
    identity  = user.identities.where(provider: 'prefinery').first

    if identity
      Prefinery.confirm_tester(user)
      redirect_to waitlists_share_path position: identity.access_token
    else
      redirect_to :root, notice: 'An error has occurred.'
    end
  end

  def email_confirm
  end

  def share
    @position = params[:position]
    identity  = Identity.find_by(access_token: @position)
    if identity
      @user         = identity.user
      @invite_code  = identity.access_token_secret
    end
  end

  private

  def user_params
    data = params.require(:user).permit(:email)
    data.merge(confirmed: false)
  end
end
