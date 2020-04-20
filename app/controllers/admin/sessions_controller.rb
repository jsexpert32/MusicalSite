class Admin::SessionsController < AdminsController
  skip_before_action :require_admin
  skip_before_filter :verify_authenticity_token

  def new
    @admin_session = Session.new
  end

  def create
    @admin_session = Session.new(params[:session])
    if @admin_session.valid?
      session[:admin] = true
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def destroy
    session.delete(:admin)
    redirect_to :root
  end
end
