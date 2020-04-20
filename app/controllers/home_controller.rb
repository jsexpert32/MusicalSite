class HomeController < ApplicationController
  skip_before_filter :check_valid_user, only: :index

  def index
    @tracks = Track.includes(:by_week_chart, :user, :artist_type).last(5)
  end
end
