class Admin::UsersController < AdminsController
  before_action :only_admin

  def index
    @user = User.all
  end
end
