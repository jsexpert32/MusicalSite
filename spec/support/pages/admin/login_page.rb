require 'support/base_page'

class Admin::LoginPage < BasePage
  def open
    visit new_admin_session_path
    self
  end

  def login(params)
    fill_in 'session[email]', with: params[:email]
    fill_in 'session[password]', with: params[:password]
    click_button 'Login'
  end
end
