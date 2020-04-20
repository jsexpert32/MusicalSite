class Comment < ActiveRecord::Base
  acts_as_nested_set scope: [:commentable_id, :commentable_type]

  validates :body, :user, presence: true
  validate :at_least_140_characters

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  # acts_as_votable
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :critique
  has_many :soundbites

  before_create :add_critique

  scope :root_elements, -> { where(parent_id: nil) }
  scope :recent, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :send_order, -> (scope) { send(scope) if %w(recent old).include? scope }
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(user_id: user.id).order(created_at: :desc)
  }
  # Helper class method to look up all comments for
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(commentable_type: commentable_str.to_s, commentable_id: commentable_id).order(created_at: :desc)
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    new commentable: obj, body: comment, user_id: user_id
  end

  def add_critique
    if parent_critique?
      critique = Critique.create(track_id: commentable_id)
      self.critique_id = critique.id
    end
  end

  def add_score
    return unless user == critique.first.track.user
    user.score += 1
    user.save!
  end

  def remove_score
    if user != critique.first.track.user
      user.score -= 1
      user.save!
    end
    critique.delete
  end

  def parent_critique?
    parent_id.nil? && user_id.to_i != Track.find(commentable_id).user.id.to_i
  end

  # helper method to check if a comment has children
  def children?
    children.any?
  end

  private

  def at_least_140_characters
    if body.length < 140 && body.length.positive? && user_id.to_i != Track.find(commentable_id).user_id.to_i
      errors.add(:body, ' must contain at least 140 characters')
    end
  end
end
