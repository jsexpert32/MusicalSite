Rails.application.configure do
  config.cache_classes                              = true
  config.eager_load                                 = true
  config.consider_all_requests_local                = false
  config.action_controller.perform_caching          = true
  config.serve_static_files                         = true
  config.assets.js_compressor                       = :uglifier
  config.assets.compile                             = true
  config.assets.digest                              = true
  config.log_level                                  = :info
  config.action_controller.asset_host               = ENV['CLOUDFRONT_URL']

  config.action_mailer.default_url_options          = { host: 'beatthread.com' }
  config.i18n.fallbacks                             = true
  config.active_support.deprecation                 = :notify
  config.log_formatter                              = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration  = false
  config.action_mailer.delivery_method              = :mailgun
  config.action_mailer.mailgun_settings = {
    api_key: ENV['MAILGUN_SECRET_KEY'],
    domain: 'beatthread.com'
  }
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    authentication: :plain,
    port: 465,
    ssl: true,
    domain: ENV['MAILGUN_DOMAIN'],
    user_name: ENV['MAILGUN_USERNAME'],
    password: ENV['MAILGUN_PASSWORD']
  }
  config.action_mailer.default_url_options = { host: 'beatthread.com' }
end
