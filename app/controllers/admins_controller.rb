class AdminsController < ApplicationController
  layout 'no_nav'
  before_action :require_admin
  skip_before_filter :check_valid_user
end
