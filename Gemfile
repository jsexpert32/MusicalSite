source 'http://rubygems.org'
ruby '2.3.1'

# Application engine
gem 'rails', '~> 4.2.6'

# Application server
gem 'puma'

# Database adapters
gem 'pg' # PostgreSQL

# Web-serving tools
gem 'human_power' # robots.txt DSL
# gem 'secure_headers' # automatic security headers # TODO: solve the issues it causes first

# Rendering DSLs
gem 'slim-rails'
gem 'jbuilder'
gem 'jquery-ui-rails'
# Rendering helpers
gem 'country_select'
gem 'simple_form'
gem 'inline_svg'
gem 'flutie' # view helpers
gem 'paloma' # page-specific javascripts
gem 'roadie' # inline email stylesheets
gem 'premailer-rails'
gem 'lazybox'

# Vendor assets and frameworks
gem 'jquery-turbolinks'
gem 'jquery-fileupload-rails' # background uploads (with shrine and roda) frontend part
gem 'jquery-atwho-rails'
gem 'turbolinks', '~> 5.0.0'
gem 'parsley-rails' # frontend form validations
gem 'animate-rails' # css animations
gem 'jquery-rails'
gem 'gemoji'
gem 'bulma-rails', '~> 0.0.28'
gem 'customize-rails'

source 'http://rails-assets.org' do
  gem 'rails-assets-oboe'
  gem 'rails-assets-pace'
  gem 'rails-assets-magic'
  gem 'rails-assets-tether'
  gem 'rails-assets-drop'
  gem 'rails-assets-offline'
  gem 'rails-assets-layzr.js'
  gem 'rails-assets-sortable'
  gem 'rails-assets-messenger'
  gem 'rails-assets-masked-input'
  gem 'rails-assets-fastclick'
  gem 'rails-assets-clipboard'
  gem 'rails-assets-sanitize-css'
  gem 'rails-assets-jquery-ui'
  gem 'rails-assets-jquery.atwho'
  gem 'rails-assets-Countable'
  gem 'rails-assets-jquery-file-upload'
end

gem "uikit-rails" # used for dropdowns etc.
group :assets do
  # DSLs
  gem 'coffee-rails'
  gem 'sass-rails'

  # Compilation
  gem 'autoprefixer-rails'
  gem 'uglifier'
end

# Tracking services
# gem 'ahoy_matey' # internal
gem 'coveralls', require: false
gem 'mixpanel-ruby'
gem 'rack-tracker'
gem 'appsignal'
gem 'thelpers'
gem 'faraday' # HTTP Client

# External APIs and services
gem 'mailgun_rails'
gem 'soundcloud'
gem 'httparty', '= 0.13.7'
gem 'twitter'
gem 'aws-sdk' # dependency for shrine
gem 'social_shares' # pages sharing stats

# Users management
gem 'bcrypt-ruby'
gem 'omniauth-twitter'

gem 'fastimage'
gem 'mini_magick'
gem 'image_processing'
# Image tools
gem 'cloudinary'
gem 'carrierwave'
gem 'ufujs-rails'
gem 'carrierwave-base64'

# Image generators
gem 'geo_pattern' # backgrounds
gem 'identicon'

# Audio tools
# gem 'taglib-ruby' # metadata processing
gem 'streamio-ffmpeg'
gem 'wavefile', '0.6.0'

# Miscellaneous
gem 'roda' # shrine dependency for background uploading
gem 'hooks' # ruby extensions
gem 'shrine' # attachments
gem 'sidekiq' # background jobs
gem 'sidekiq-cron' # background cron jobs
gem 'sidekiq-failures'
gem 'rubyzip' # zip archives processing
gem 'memoist' # memoize computations
gem 'rollout' # feature flippers
gem 'kaminari' # pagination
gem 'mailboxer'
gem 'friendly_id' # slugs
gem 'recommendable' # likes/dislikes engine
gem 'by_star', github: 'radar/by_star' # datetime based AR finders
gem 'acts_as_commentable_with_threading'
gem 'shortener'
gem 'nokogiri'

# Development tools to be present in all environments
gem 'awesome_print', require: false # pretty printing for in-console debugging convenience
gem 'stackprof'
gem 'rack-mini-profiler'
gem 'memory_profiler'
gem 'flamegraph'

group :development do
  gem 'brakeman', require: false
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'letter_opener'
  gem 'letter_opener_web', '~> 1.2.0'
  gem 'railroady' # generate model and controller diagrams
  gem 'derailed_benchmarks'
  gem 'bullet'
  gem 'slack-notifier'
end

group :development, :test do
  gem 'byebug'
  gem 'rubocop'
  gem 'quiet_assets'
  gem 'bundler-audit', require: false
  gem 'therubyracer' # for uglifier # unnecessary on Heroku
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
  gem 'minitest-rails'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
end

gem 'faker' # used in seeds.rb
group :test do
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'shoulda-matchers', require: false
  gem 'capybara-email'
  gem 'poltergeist'
  gem 'phantomjs'
  gem 'rspec-retry'
end

group :staging, :production do
  gem 'rack-cors', require: 'rack/cors'
  gem 'rails_12factor' # heroku requirement
end
