class BeatsController < ApplicationController
  include BeatFilters

  def index
    @page          = 20
    @genres        = Genre.all

    if params[:filters].blank?
      @tracks =  Track.includes(:by_week_chart, :user, :artist_type)
                      .time_ago(:all).page(params[:page]).per(@page)
    else
      filters
    end
  end

  def social_share
    @track = Track.find(params[:track_id])
  end
end
