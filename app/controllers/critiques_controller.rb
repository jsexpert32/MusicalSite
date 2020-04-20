class CritiquesController < ApplicationController
  def show
    @track = Track.includes(:user).find_by(id: params[:track_id])
    @comments = @track.root_comments.includes(:user).send_order(params[:sort])
    render layout: 'critique'
  end
end
