class BeatWorker
  include Sidekiq::Worker

  def perform(*args)
    if args[0]['type'] == 'CHARTED'
      puts '***** BEATWORKER WORKING: CHARTED *****'
      Track::Charted.charted
    elsif args[0]['type'] == 'WEEK'
      puts '***** BEATWORKER WORKING: WEEK *****'
      Track::Charted.this_week
    elsif args[0]['type'] == 'MONTH'
      puts '***** BEATWORKER WORKING: MONTH *****'
      Track::Charted.this_month
    end
  end
end
