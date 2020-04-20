class PasswordResetsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :find_user, only: [:edit, :update]

  def new; end

  def create
    user = User.find_by(email: params[:email])
    return user.send_password_reset if user
    @error = 'Please try again with other information'
    render :new
  end

  def update
    if @user.password_reset_sent_at < 12.hours.ago
      redirect_to new_password_reset_path
    elsif @user.update_attributes(user_params)
      redirect_to :root
    else
      render :edit
    end
  end

  private

  def find_user
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
