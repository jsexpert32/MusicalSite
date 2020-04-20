class ApplicationController < ActionController::Base
  include VerifierConcern

  protect_from_forgery with: :exception

  before_filter :check_rack_mini_profiler
  before_filter :check_valid_user

  helper_method :current_user
  helper_method :current_admin

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
  rescue ActiveRecord::RecordNotFound
    reset_session
  end

  def require_guest
    redirect_to root_path unless current_user
  end

  def require_admin
    return true if current_admin
    redirect_to root_path
  end

  def current_admin
    session[:admin]
  end

  def check_rack_mini_profiler
    Rack::MiniProfiler.authorize_request if params[:rmp].present?
  end

  def check_valid_user
    if current_user&.invalid?
      flash[:alert] = 'All fields must be completed'
      redirect_to profile_path(invalid: true)
    end
  end

  private

  def sign_in(user)
    return flash[:notice] = I18n.t('messages.info.confirm_email') unless user.confirmed?
    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
    cookies.permanent[:auth_token] = user.auth_token
    user.assign_attributes(last_activity_at: Time.now)
    user.save(validate: false)
  end
end
