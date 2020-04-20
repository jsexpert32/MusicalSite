class Rating < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates_uniqueness_of :user_id, scope: :track_id
  after_save :recommendable
  after_save :set_ratings_count
  enum status: [:like, :dislike, :indifferent]

  def recommendable
    #
    # TODO heeds refactor it use hash
    # user  = User.find(user_id)
    # track = Track.find(track_id)

    # case rating_type
    # when 'like'     then user.like(track)
    # when 'dislike'  then user.dislike(track)
    # when 'indifferent'
    #   if track.rated?
    #     user.unlike(track)
    #     user.undislike(track)
    #   end
    #   user.hide(track)
    # end
  end

  private

  def set_ratings_count
    like_count        = track.likes.count
    indifferent_count = track.indifferents.count
    dislike_count     = track.dislikes.count
    track.update_columns(like_count: like_count, indifferent_count: indifferent_count, dislike_count: dislike_count)
  end
end
