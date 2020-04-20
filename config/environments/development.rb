Rails.application.configure do
  config.cache_classes                         = false
  config.eager_load                            = false
  config.consider_all_requests_local           = true
  config.action_controller.perform_caching     = false
  config.action_controller.default_url_options = { host: 'http://localhost:3000' }
  config.action_mailer.raise_delivery_errors   = false
  config.action_mailer.delivery_method         = :letter_opener
  config.action_mailer.asset_host              = 'http://localhost:3000'
  config.action_mailer.default_url_options     = { host: 'http://0.0.0.0:3000' }
  config.active_support.deprecation            = :log
  config.active_record.migration_error         = :page_load
  config.assets.debug                          = true
  config.assets.raise_runtime_errors           = true

  config.after_initialize do
    Bullet.enable         = true
    Bullet.alert          = true
    Bullet.bullet_logger  = true
    Bullet.console        = true
    Bullet.rails_logger   = true
    Bullet.add_footer     = true
    Bullet.stacktrace_includes = []
    Bullet.stacktrace_excludes = []
    Bullet.slack = {
      channel:      '#devbots',
      username:     'BulletBot',
      webhook_url:  'https://hooks.slack.com/services/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'
    }
  end
end
