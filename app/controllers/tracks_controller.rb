class TracksController < ApplicationController
  before_action :track, only: [:new, :edit]
  before_action :genres, only: [:new, :edit]

  def index
    @tracks = Track.all
  end

  def show
    @my_tracks = Array.new(1, @track)

    @likes_count = @track.likes.count
    @dislikes_count = @track.dislikes.count
    @indifferences_count = @track.indifferences.count
    @has_like = Rating.find_by(user: current_user, track: @track).present?

    @comments = @track.comment_threads
    @comment = Comment.new
  end

  def new
    @beat_deficit = current_user.commented_tracks.count <= current_user.track_count - 20
    respond_to do |format|
      format.html
      format.json { render json: Genre.find_by(id: params[:genre_id])&.subgenres }
    end
  end

  def create
    @track = current_user.tracks.new(track_params)
    if @track.save
      Shortener::ShortenedUrl.generate("/tracks/#{@track.id}")
      redirect_to artist_track_list_path(current_user.id), notice: 'Track created!'
    else
      genres
      flash[:danger] = error_message
      redirect_to new_track_path
    end
  end

  def update
    respond_to do |format|
      if track.update track_params
        format.json { head :ok }
        format.html do
          redirect_to artist_track_list_path(current_user.id),
                      notice: 'Track was successfully updated.'
        end
      else
        genres
        format.json { head :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end

  def destroy
    track.destroy if current_user == track.user
    respond_to do |format|
      format.html do
        redirect_to artist_track_list_path(current_user.id),
                    notice: 'Track was successfully destroyed.'
      end
    end
  end

  private

  def track_params
    params.require(:track).permit(:audio, :image, :cached_image_data, :user_id,
                                  :audio_remote_url, :title, :description, :streamable,
                                  :contactable, :sharing, genre_ids: [], subgenre_ids: [])
  end

  def genres
    @genres ||= Genre.all
  end

  def track
    @track ||= Track.find_or_initialize_by(id: params[:id])
  end

  def error_message
    @track.errors.messages[:audio].grep(/type/).any? ? 'This type is not allowed' : 'Track is way too large'
  end
end
