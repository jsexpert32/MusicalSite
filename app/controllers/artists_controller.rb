class ArtistsController < ApplicationController
  before_filter :set_user, except: :track_list
  before_filter :set_background_image, except: :track_list
  before_action :set_artist, only: :track_list

  def viewer_side_unpopulated; end

  def user_side_about; end

  def user_side_first_time; end

  def viewer_side_populated; end

  # Method for listing out the track list for the particular artist
  def track_list
    @artist_tracks = params[:order] ? @artist.tracks.includes(:by_week_chart, :artist_type).sorted_by_sort_name(params[:order]) : @artist.tracks.includes(:by_week_chart, :artist_type).order(created_at: :desc)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    (@filterrific = initialize_filterrific(
      Track,
      params[:filterrific],
      select_options: { sorted_by: Track.options_for_sorted_by_extended }
    )) || return

    @tracks = @filterrific.find.where(user_id: @user.id)

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def edit; end

  private

  def set_background_image
    @background_image = if @user.background_image.url
                          "url(#{@user.background_image.url})"
                        else
                          GeoPattern.generate('Mastering Markdown').to_data_uri
                        end
  end

  def set_user
    @user = User.find_by_slug(request.subdomain)
    redirect_to root_url(subdomain: false) unless @user
  end

  def set_artist
    @artist = User.find(params[:artist_id])
  end
end
