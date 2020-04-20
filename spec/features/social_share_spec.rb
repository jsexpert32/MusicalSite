require 'rails_helper'

feature 'Social Share' do
  let(:social_share) { SocialShare.new }

  before do
    create(:track)
  end

  scenario 'modal', js: true do
    social_share.open
    expect(page).to have_no_css('.social-box')
    social_share.open_modal
    expect(page).to have_css('.social-box')
    expect(page).to have_css('.uk-icon-twitter')
    expect(page).to have_css('.uk-icon-facebook')
    expect(page).to have_css('.uk-icon-tumblr')
    expect(page).to have_css('.uk-icon-google-plus')
    expect(page).to have_css('.uk-icon-envelope')
    expect(page).to have_css('#social-share-close')
    social_share.close_modal
    expect(page).to have_no_css('social-box')
  end
end
