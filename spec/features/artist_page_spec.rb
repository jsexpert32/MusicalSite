require 'rails_helper'

feature 'Track Uploading' do
  let!(:user) { create(:user) }
  let(:genre) { create(:genre, name: 'Hip-Hop') }
  let(:subgenre_first) { create(:subgenre, name: 'West Coast Hip-Hop', genre: genre) }
  let(:subgenre_second) { create(:subgenre, name: 'Crunk', genre: genre) }
  let!(:track_first) { create(:track, genres: [genre], subgenres: [subgenre_first, subgenre_second], user: user) }
  let!(:track_second) { create(:track, user: user) }
  let(:artist_page) { ArtistPage.new }
  let(:track_attributes) { { title: Faker::Book.title, description: Faker::Lorem.paragraph } }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  scenario "user's tracks", js: true do
    artist_page.open(user)
    expect(page).to have_content('2 BEATS')
    expect(page).to have_selector("div[data-id='#{track_first.id}']")
    expect(page).to have_selector("div[data-id='#{track_second.id}']")
    artist_page.click_edit_track(track_second.id)
    expect(current_path).to eq edit_track_path(track_second.id)
    expect(page).to have_content('CHOOSE AUDIO FILE TO UPLOAD')
    expect(page).to have_selector('select', count: 3)
    expect(page).to have_select('track[genre_ids][]', with_options: [genre.name])
    expect(page).to have_select('track[subgenre_ids][]', with_options: [], count: 2)
    expect(page).to have_select('track[genre_ids][]', selected: 'Choose Genre')
    expect(page).to have_select('track[subgenre_ids][]', selected: 'Choose Subgenre', count: 2)
    artist_page.change_track(track_attributes)
    expect(current_path).to eq artist_track_list_path(user)
    expect(track_second.reload.title).to eq track_attributes[:title]
    artist_page.click_edit_track(track_first.id)
    expect(current_path).to eq edit_track_path(track_first.id)
    expect(page).to have_select('track[genre_ids][]', selected: 'Hip-Hop')
    expect(page).to have_select('track[subgenre_ids][]', selected: 'West Coast Hip-Hop')
    expect(page).to have_select('track[subgenre_ids][]', selected: 'Crunk')
    artist_page.change_track(track_attributes)
    expect(current_path).to eq artist_track_list_path(user)
    expect(track_first.reload.title).to eq track_attributes[:title]
  end

  scenario 'delete track', js: true do
    artist_page.open(user)
    expect(page).to have_content('2 BEATS')
    expect(user.tracks.count).to eq 2
    artist_page.click_edit_track(track_second.id)
    expect(current_path).to eq edit_track_path(track_second.id)
    artist_page.delete_track
    expect(current_path).to eq artist_track_list_path(user)
    expect(page).to have_content('ONE BEAT')
    expect(user.tracks.count).to eq 1
  end

  scenario 'cancel edit track', js: true do
    artist_page.open(user)
    expect(page).to have_content('2 BEATS')
    artist_page.click_edit_track(track_second.id)
    expect(current_path).to eq edit_track_path(track_second.id)
    artist_page.cancel_edit_track
    expect(current_path).to eq artist_track_list_path(user)
    expect(page).to have_content('2 BEATS')
  end
end
