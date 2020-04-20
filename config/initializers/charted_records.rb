if Rails.env.development?
  unless File.basename($PROGRAM_NAME) == 'rake'
    Track::Charted.this_week
    Track::Charted.this_month
    Track::Charted.charted
  end
end
