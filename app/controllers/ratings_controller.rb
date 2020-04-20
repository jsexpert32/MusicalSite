class RatingsController < ApplicationController
  def create_or_update
    rating = Rating.where(user_id: current_user.id, track_id: params[:track]).first_or_initialize
    rating.update_attributes(status: Rating.statuses[params[:star]])
    rating_count = rating_count(params[:track])
    rating_count[:star] = params[:star]
    render json: rating_count
  end

  private

  def rating_count(track_id)
    rating = Rating.where(track_id: track_id)
    {
      likes: rating.like.count,
      dislikes: rating.dislike.count,
      indifference: rating.indifferent.count
    }
  end
end
