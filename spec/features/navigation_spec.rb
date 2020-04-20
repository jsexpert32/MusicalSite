require 'rails_helper'

feature 'Navigation' do
  let!(:user) { create(:user) }
  let(:navigation) { Navigation.new }

  before do
    create(:track)
    cookies = OpenStruct.new(auth_token: user.auth_token, permanent: { auth_token: user.auth_token })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario 'dropdown', js: true do
    navigation.open
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    expect(page).to have_css('.dropdown__content')
    expect(page).to have_css('a', text: 'PROFILE')
    expect(page).to have_css('a', text: 'MY ARTIST PAGE')
    expect(page).to have_css('a', text: 'PRODUCT')
    expect(page).to have_css('a', text: 'SETTINGS')
    expect(page).to have_css('a', text: 'SIGN OUT')

    expect(page).to have_css('a', text: 'Legal')
    expect(page).to have_css('a', text: 'Copyright')
    expect(page).to have_css('a', text: 'Help')

    expect(page).to have_content(user.name)
    navigation.dropdown_close
    expect(page).to have_no_css('.dropdown__conten')
  end

  scenario 'signout', js: true do
    navigation.open
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    expect(page).to have_css('.dropdown__content')
    expect(page).to have_no_css("a[href='/signup']", text: 'CREATE AN ACCOUNT')
    navigation.signout
    expect(page).to have_css("a[href='/signup']", text: 'CREATE AN ACCOUNT')
  end

  scenario 'open profile', js: true do
    navigation.open
    expect(page.current_path).to eq '/home'
    expect(page).to have_no_css('.dropdown__content')
    navigation.dropdown_open
    expect(page).to have_css('.dropdown__content')
    navigation.open_profile
    expect(page.current_path).to eq '/profile'
  end
end
