class ChartsController < ApplicationController
  def index
    @page = 20
    @tracks = Track.includes(:by_week_chart, :user, :artist_type)
                   .charted_by_period(params[:period]).page(params[:page]).per(@page)
    @tracks = @tracks.reverse_order.page(params[:page]).per(@page) if params[:direction] == 'asc'
  end
end
