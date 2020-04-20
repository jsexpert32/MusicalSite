require 'support/base_page'

class ProfilePage < BasePage
  def open
    visit profile_path
    self
  end

  def change_url
    visit beats_path
  end

  def change_profile(attributes = [])
    attributes.each do |attr, value|
      next if attr == :email
      fill_in "user[#{attr}]", with: value
    end
    click_button 'SAVE'
  end

  def change_avatar
    find("label[for='inputFile']").trigger :click
    attach_file('user[avatar]', "#{Rails.root}/spec/fixtures/artofcool.jpg", visible: false)
  end
end
