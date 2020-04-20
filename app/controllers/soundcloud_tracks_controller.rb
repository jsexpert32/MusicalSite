class SoundcloudTracksController < ApplicationController
  include SoundcloudTracksImport

  before_action :require_guest
  before_action :check_beat_deficit
  before_action :check_client
  before_action :count_tracks, only: :index

  PAGE_SIZE = 5

  def index
    result = params[:url] ? client.get(params['url']) : client.get('/me/tracks', limit: PAGE_SIZE, linked_partitioning: params[:page])
    @tracks = result['collection']
    @next_href = result['next_href']
    @count_tracks = params[:count_tracks] unless @count_tracks
    @show_link = @count_tracks.to_i > PAGE_SIZE
  end

  def create
    return redirect_to soundcloud_tracks_path, notice: I18n.t('soundloud_page.check_to_import') unless import_tracks[:ids]
    import_tracks[:ids].each do |id|
      data = client.get("/tracks/#{id}")
      track = current_user.tracks.new track_params(data)
      Shortener::ShortenedUrl.generate("/tracks/#{track.id}") if track.save
    end
    @count_tracks = import_tracks[:count_tracks]
    redirect_to soundcloud_tracks_path, notice: I18n.t('soundloud_page.tracks_have_been_imported')
  end

  private

  def client
    @client ||= Sound.connect(identity.access_token)
  end

  def identity
    @identity ||= current_user.identities.find_by(provider: 'soundcloud')
  end

  def import_tracks
    params.require(:import_tracks).permit(:count_tracks, ids: [])
  end
end
