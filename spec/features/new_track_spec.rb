require 'rails_helper'

feature 'Track Uploading' do
  let!(:user) { create(:user) }
  let!(:genre) { create(:genre) }
  let!(:subgenre_first) { create(:subgenre, name: 'West Coast Hip-Hop', genre: genre) }
  let!(:subgenre_second) { create(:subgenre, name: 'Crunk', genre: genre) }
  let(:new_track_page) { NewTrackPage.new }
  let(:other_track) { create(:track) }
  let(:critique) { create(:critique, track: other_track) }
  let!(:comment) { create(:comment, user: user, critique: critique, commentable: other_track) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  scenario 'Track uploading buttons exist', js: true do
    new_track_page.open
    expect(page).to have_content('UPLOAD A BEAT OR IMPORT FROM SOUNDCLOUD')
    expect(page).to have_selector('[data-upload-content]')
    expect(page).to have_selector('.beat-uploading__choose-file')
    expect(page).to have_content('CHOOSE FILE TO UPLOAD')
    expect(page).to have_selector('.beat-uploading__file')
    expect(page).to have_content('THEN CHOOSE BEATS TO IMPORT')
    expect(page).to have_selector('.beat-uploading__choose-file.beat-uploading__choose-file--scloud')
    expect(page).to have_field('track[audio]', visible: false)
    expect(find('.beat-uploading__choose-file.beat-uploading__choose-file--scloud img')['src']).to have_content('soundcloud-logo')
  end

  scenario 'Uploading modal window exists', js: true do
    new_track_page.open
    new_track_page.attach_audio

    within '.beat-uploading-content' do
      expect(page).to have_selector('.uploading-progress')
      expect(page).to have_selector('.beat-uploading__left')
      expect(page).to have_selector('.beat-uploading-right')
      expect(page).to have_selector("img[id='image_upload_preview']")
      expect(page).to have_selector("label[for='inputFile']")
      expect(page).to have_content('ADD IMAGE')
      expect(page).to have_selector("input[placeholder='Beat Title']")
      expect(page).to have_selector("textarea[name='track[description]']")
      expect(page).to have_selector("textarea[placeholder='Add information about your beat']")
      expect(page).to have_selector("img[alt='Eye one']")
      expect(page).to have_selector("img[alt='Eye two']")
      expect(page).to have_content('PRIVATE')
      expect(page).to have_content('PUBLIC')
      expect(page).to have_selector('select', count: 1)
      expect(page).to have_selector("label[for='contactable']")
      expect(page).to have_content('Allow people to contact me about this beat.')
      expect(page).to have_content('Share your sounds')
      expect(page).to have_selector('.sharing__checks')
      expect(page).to have_selector('.twitter')
      expect(page).to have_selector('.facebook')
      expect(page).to have_selector('.tumblr')
      expect(page).to have_selector("input[value='finish']")
      expect(page).to have_content('CANCEL')
    end
  end

  scenario 'Uploading modal window closes', js: true do
    new_track_page.open
    new_track_page.attach_audio

    find("a[id='close-form']").trigger :click
    expect(page).not_to have_selector('.beat-uploading-content')
  end

  scenario 'Dropdowns display genres and subgenres', js: true do
    new_track_page.open
    new_track_page.attach_audio

    within '.beat-uploading-content' do
      select 'Hip-Hop', from: 'track[genre_ids][]'
      expect(page).to have_selector('select', count: 3)
      new_track_page.append_subgenres_with_js
      expect(page).to have_select('track[subgenre_ids][]', with_options: ['West Coast Hip-Hop', 'Crunk'], count: 2)
    end
  end

  # scenario 'Uploading fails and outputs validation errors', js: true do
  #   new_track_page.open
  #   new_track_page.attach_audio
  #
  #   within '.beat-uploading-content' do
  #     click_on 'finish'
  #     expect(page).to have_content("can't be blank", count: 2)
  #   end
  # end
end
