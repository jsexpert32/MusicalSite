require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'

Bundler.require(*Rails.groups(assets: %i(development test)))

module Beat
  class Application < Rails::Application
    config.generators do |g|
      g.assets   = false
      g.helper   = false
      g.jbuilder = false
    end

    console do
      require_relative '../lib/patches/irb' if defined? IRB
      require 'awesome_print'
      # AwesomePrint.defaults = { raw: true } #, limit: true, sort_keys: true
      AwesomePrint.irb!
      AwesomePrint.pry!
    end

    config.serve_static_files = true
    config.middleware.use JQuery::FileUpload::Rails::Middleware
    config.middleware.use Rack::Deflater

    config.active_record.raise_in_transactional_callbacks = true

    config.assets.paths << Rails.root.join('vendor', 'assets')
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.paths << Emoji.images_path

    config.assets.precompile << %w(*.gif *.png *.svg *.ttf *.woff *.woff2 *.jpg)
    config.secret_key_base = ENV['SECRET_KEY_BASE'].presence
  end
end

Rails.application.secrets.each { |key, value| ENV[key.to_s] ||= value.to_s }

require_relative '../lib/utility/shrine'
