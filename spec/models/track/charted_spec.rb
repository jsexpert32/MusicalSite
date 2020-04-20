require 'rails_helper'

RSpec.describe Track::Charted, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:track) }
  end

  describe 'Properties check' do
    it 'Month object' do
      datetime            = DateTime.now
      month_track_charted = Track::Charted.create!(
        track_id: 111,
        year:     datetime.year,
        month:    datetime.month,
        day:      datetime.day,
        date:     datetime,
        position: 1
      )
      expect(month_track_charted.year).to eq(datetime.year)
      expect(month_track_charted.month).to eq(datetime.month)
      expect(month_track_charted.day).to eq(datetime.day)
      expect(month_track_charted.date).to eq(datetime)
    end

    it 'Week object' do
      datetime           = DateTime.now
      week_track_charted = Track::Charted.create!(
        track_id: 111,
        year:     datetime.year,
        week:     datetime.cweek,
        day:      datetime.day,
        date:     datetime,
        position: 1
      )
      expect(week_track_charted.year).to eq(datetime.year)
      expect(week_track_charted.week).to eq(datetime.cweek)
      expect(week_track_charted.day).to eq(datetime.day)
      expect(week_track_charted.date).to eq(datetime)
    end

    it 'month duplicate record' do
      datetime                = DateTime.now
      month_track_charted     = Track::Charted.new(
        track_id: 111,
        year:     datetime.year,
        month:    datetime.month,
        day:      datetime.day,
        date:     datetime,
        position: 1
      )
      month_track_charted_dup = Track::Charted.new(
        track_id: 111,
        year:     datetime.year,
        month:    datetime.month,
        day:      datetime.day,
        date:     datetime,
        position: 2
      )
      month_track_charted.save!
      expect { month_track_charted_dup.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Track has already been taken')
    end

    it 'week duplicate record' do
      datetime               = DateTime.now
      week_track_charted     = Track::Charted.new(
        track_id: 111,
        year:     datetime.year,
        week:     datetime.cweek,
        day:      datetime.day,
        date:     datetime,
        position: 1
      )
      week_track_charted_dup = Track::Charted.new(
        track_id: 111,
        year:     datetime.year,
        week:     datetime.cweek,
        day:      datetime.day,
        date:     datetime,
        position: 2
      )
      week_track_charted.save!
      expect { week_track_charted_dup.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Track has already been taken')
    end
  end
end
