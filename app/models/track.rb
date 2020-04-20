class Track < ActiveRecord::Base
  include AudioUploader[:audio]
  include ImageUploader[:image]
  mount_base64_uploader :cover, CoverUploader

  include TrackFilter

  belongs_to :user
  belongs_to :artist_type
  has_many :ratings, dependent: :destroy
  has_many :critiques, dependent: :destroy
  has_many :comments
  has_many :users, through: :comments
  has_many :subgenres_genre, -> { order('subgenres.id') },
           through: :genres, source: :subgenres
  has_many :track_charted, class_name: Track::Charted

  has_and_belongs_to_many :genres, dependent: :destroy
  has_and_belongs_to_many :subgenres, dependent: :destroy

  validates :title, :description, :image, presence: true

  after_save :update_score
  after_create :track_count

  acts_as_commentable

  scope :rating_gte, lambda { |rating|
    where('rating >= ?', rating.to_i)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = sort_option =~ /desc$/ ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("tracks.created_at #{direction}")
    when /^rating/
      order("tracks.rating #{direction}")
    when /^charted/
      order('rating DESC').limit(100)
    else
      raise ArgumentError, "Invalid sort option: #{sort_option.inspect}"
    end
  }

  scope :with_genre, lambda{ |genre_ids|
    joins(:genres).where(genres: { id: genre_ids })
  }

  scope :charted, -> { where(is_charted: true) }

  scope :sorted_by_sort_name, lambda { |order_name|
    order(options_for_sorted_by.find { |o| o.first[order_name] }.last)
  }

  delegate :username, to: :user

  def self.time_ago(time)
    track_arel = Track.arel_table
    time_range = case time
                 when '24hrs'  then  24.hours.ago
                 when 'week'   then  1.week.ago
                 when 'month'  then  1.month.ago
                 when 'year'   then  1.year.ago
                 else
                   Track.first.try(:created_at) || Time.now
                 end
    where(track_arel[:created_at].gteq(time_range))
  end

  def visible?
    streamable ? true : false
  end

  def self.options_for_sorted_by
    [
      ['Newest - Oldest', 'created_at desc'],
      ['Oldest - Newest', 'created_at asc']
    ]
  end

  def self.options_for_sorted_by_extended
    [
      ['Newest - Oldest', 'created_at_desc'],
      ['Oldest - Newest', 'created_at_asc'],
      ['Rating asc', 'rating_asc'],
      ['Rating desc', 'rating_desc'],
      %w(Charted charted)
    ]
  end

  def update_score
    return unless marked_changed?
    if marked == true
      user.score -= 1
    else
      user.score += 1
    end
    user.save!
  end

  def track_count
    Tracker.track(
      {
        beat_name: title,
        track_author: user.username,
        all_beats_count: Track.count,
        users_track_count: user.tracks.count
      }, 'Beat Uploaded'
    )
  end

  def chart_number
    order_number = 0
    tracks = Track.select('id').order(rating: :desc).limit(100)
    tracks.each_with_index do |track, i|
      order_number = i + 1
      next if track.id == id
    end
    order_number
  end

  def ratings_count(rating_type)
    ratings.where(rating_type: rating_type).count
  end

  def self.random
    order('RANDOM()').first
  end
end
