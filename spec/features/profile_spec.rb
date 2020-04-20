require 'rails_helper'

feature 'Profile' do
  let(:new_email) { 'new_email@example.com' }
  let(:profile_page) { ProfilePage.new }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'valid user' do
    let!(:user) { create(:user) }
    let(:valid_params) { { email: new_email } }
    let(:invalid_params) { { email: '' } }

    scenario 'Update user profile', js: true do
      profile_page.open
      expect(page.current_path).to eq '/profile'
      expect(page).to have_content('PROFILE')

      expect(page).to have_field('user[avatar]', visible: false)
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.city)
      expect(page).to have_select('user[country]', selected: translation_country(user.country), visible: false)
      expect(page).to have_content(user.username)

      # expect(page).to have_no_field('user[password]')
      # expect(page).to have_no_field('user[password_confirmation]')

      profile_page.change_avatar
      profile_page.change_profile

      profile_page.change_profile(invalid_params)
      expect(page).to have_no_css('.toast-message')

      profile_page.change_profile(valid_params)
      expect(page).to have_css('.toast-message')
    end
  end

  describe 'invalid user' do
    let(:user) { build(:user, password: nil) }
    let(:invalid_params) { { password: '123456789', password_confirmation: '1234567899' } }
    let(:valid_params) { { password: '123456789', password_confirmation: '123456789' } }

    before { user.save(validate: false) }

    scenario 'password visible', js: true do
      profile_page.open
      expect(page.current_path).to eq '/profile'
      expect(page).to have_content('PROFILE')
      expect(page).to have_field('user[password]')
      expect(page).to have_field('user[password_confirmation]')

      profile_page.change_profile
      expect(page).to have_css('.error')

      profile_page.change_profile(invalid_params)
      expect(page).to have_css('.error')

      profile_page.change_profile(valid_params)
      expect(page).to have_no_css('.error')

      expect(page).to have_no_field('user[password]')
      expect(page).to have_no_field('user[password_confirmation]')
    end

    scenario 'trying to change the URL', js: true do
      profile_page.open
      expect(page.current_path).to eq '/profile'
      expect(page).to have_content('PROFILE')
      profile_page.change_url
      expect(page.current_path).to eq '/profile'
    end

    scenario 'change the URL after update profile', js: true do
      profile_page.open
      expect(page.current_path).to eq '/profile'
      expect(page).to have_content('PROFILE')
      profile_page.change_profile(valid_params)
      profile_page.change_url
      expect(page.current_path).to eq '/beats'
    end
  end

  def translation_country(country)
    ISO3166::Country[country].translations[I18n.locale.to_s]
  end
end
