require 'support/base_page'

class SignInWindow < BasePage
  def open
    visit home_index_path
    self
  end

  def email_sign_in
    find(:link, 'SIGN IN').trigger('click')
  end

  def forgot_password
    find("a.signup-link[href='/password_resets/new']", text: 'Forgot Password?').click
  end

  def twitter_sign_in
    open_form_of_choice
    find('.button.social.twitter').click
  end

  def soundcloud_sign_in
    open_form_of_choice
    find('.button.social.soundcloud').click
  end

  def open_sign_up_form
    open_form_of_choice
    find('a.button.email').click
  end

  def click_next_sign_up_form
    find('a.next-form').click
  end

  def agree_to_terms
    find('label.toggle-label').click
  end

  def submit_form
    find("button.btn[type='submit']").click
  end

  def click_next
    find('.next.tw-next').click
  end

  def set_attributes(attributes = {}, name_form = 'user')
    attributes.each do |attr, value|
      fill_in "#{name_form}[#{attr}]", with: value
    end
  end

  def open_form_of_choice
    find("#desktop-navigation a[href='/signup']").trigger('click')
  end

  def change_avatar
    find("label[for='inputFile']").trigger :click
    attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/artofcool.jpg", visible: false)
  end
end
