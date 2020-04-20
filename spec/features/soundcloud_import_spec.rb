require 'rails_helper'

feature 'Soundcloud import' do
  let(:user) { create(:user) }
  let(:import_page) { SoundcloudImportPage.new }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(SoundCloud::Client).to receive(:authorize_url).and_return(auth_callbacks_path(:soundcloud))
    allow_any_instance_of(SessionsController).to receive(:sc_identity_params).and_return(mock_soundcloud_identity_params)
    allow_any_instance_of(SoundcloudTracksImport).to receive(:data_from_url).and_return(mock_data_file(mock_audio_url))
    allow_any_instance_of(AudioUploader).to receive(:around_upload).and_return([])
    allow(user).to receive(:track_count).and_return(20)
  end

  describe 'Import tracks' do
    let(:other_track) { create(:track) }
    let(:critique) { create(:critique, track: other_track) }
    let!(:comment) { create(:comment, user: user, critique: critique, commentable: other_track) }
    let(:other_track_second) { create(:track) }
    let(:critique_second) { create(:critique, track: other_track_second) }
    let!(:comment_second) { create(:comment, user: user, critique: critique_second, commentable: other_track_second) }

    scenario 'soundcloud', js: true do
      import_page.open_new_track
      expect(page).to have_content('20 BEATS') # track_count = 20
      reassign_client_get mock_track_collection_params
      import_page.choose_import_track
      expect(page.current_path).to eq soundcloud_tracks_path
      expect(user.tracks.count).to eq 0
      expect(page).to have_content('ONE SONG IN SOUNDCLOUD')
      expect(page).to have_unchecked_field('import_tracks[ids][]', visible: false)
      import_page.choose_track
      expect(page).to have_checked_field('import_tracks[ids][]', visible: false)
      reassign_client_get mock_track_params
      import_page.import_track
      reassign_client_get mock_track_collection_params
      expect(page.current_path).to eq soundcloud_tracks_path
      expect(user.tracks.count).to eq 1
    end
  end

  scenario 'beat dificit', js: true do
    import_page.open_new_track
    expect(page).to have_content('20 BEATS')
    import_page.click_label_import_track
    expect(page).to have_content('You need to leave a critique for other tracks')
  end

  scenario 'redirect when beat dificit', js: true do
    import_page.open_soundcloud_tracks
    expect(page).to have_content('20 BEATS')
    expect(page.current_path).to eq new_track_path
  end

  def reassign_client_get(result)
    allow_any_instance_of(SoundCloud::Client).to receive(:get).and_return(result)
  end
end
