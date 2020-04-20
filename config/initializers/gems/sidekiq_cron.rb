Sidekiq::Cron::Job.create(name: 'Beat worker for charted tracks', cron: '*/30 * * * *', class: 'BeatWorker', args: { type: 'CHARTED' })
Sidekiq::Cron::Job.create(name: 'Beat worker for week - every day', cron: '0 0 * * *', class: 'BeatWorker', args: { type: 'WEEK' })
Sidekiq::Cron::Job.create(name: 'Beat worker for month - every Week', cron: '0 0 * * 0', class: 'BeatWorker', args: { type: 'MONTH' })
