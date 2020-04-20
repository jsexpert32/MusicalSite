class Track::Charted < ActiveRecord::Base
  self.table_name = 'track_charted'

  belongs_to :track
  validates :track_id, uniqueness: { scope: [:year, :month, :week] }
  validates :position, uniqueness: { scope: [:year, :month, :week] }

  scope :by_this_week, -> (time = DateTime.now) { where(year: time.year, week: time.cweek) }
  scope :by_this_month, -> (time = DateTime.now) { where(year: time.year, month: time.month) }
  scope :by_all_time, -> { where(year: nil, month: nil, week: nil) }

  class << self
    # TODO: need cron job to run these methods
    def this_week
      datetime      = DateTime.now
      track_charted = Track.charted_by_period_job('charts_by_week_job')

      Track::Charted.by_this_week.update_all(position: nil)

      track_charted.each_with_index do |track, index|
        charted = Track::Charted.find_or_create_by(
          track_id: track.id,
          year: datetime.year,
          week: datetime.cweek
        )
        charted.date      = datetime
        charted.position  = index + 1
        charted.track.update(is_charted: true) if charted.save
      end

      Track::Charted.by_this_week.where.not(track_id: track_charted.map(&:id)).delete_all

      'DONE'
    end

    def this_month
      datetime      = DateTime.now
      track_charted = Track.charted_by_period_job('charts_by_month_job')

      Track::Charted.by_this_month.update_all(position: nil)

      track_charted.each_with_index do |track, index|
        charted = Track::Charted.find_or_create_by(
          track_id: track.id,
          year: datetime.year,
          month: datetime.month
        )
        charted.date      = datetime
        charted.position  = index + 1
        charted.track.update(is_charted: true) if charted.save
      end

      Track::Charted.by_this_month.where.not(track_id: track_charted.map(&:id)).delete_all

      'DONE'
    end

    def charted
      datetime      = DateTime.now
      track_charted = Track.charted_by_period_job('charts_by_all_time_job')

      Track::Charted.by_all_time.update_all(position: nil)

      track_charted.each_with_index do |track, index|
        charted = Track::Charted.find_or_create_by(
          track_id: track.id,
          year: nil,
          month: nil,
          week: nil
        )
        charted.date      = datetime
        charted.position  = index + 1
        charted.track.update(is_charted: true) if charted.save
      end

      Track::Charted.by_all_time.where.not(track_id: track_charted.map(&:id)).delete_all

      'DONE'
    end
  end
end
