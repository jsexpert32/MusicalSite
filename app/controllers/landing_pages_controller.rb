class LandingPagesController < ApplicationController
  def new
    @beat = Track.new
  end

  def email_template; end

  def soundcloud; end

  def beat_uploading; end

  def beat
    @tracks = Track.all
  end

  def charts
    @tracks = Track.all
  end
end
