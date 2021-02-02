require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DatoRss
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.active_record.schema_format = :sql

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: %i[get post put patch delete options head], expose: %w[Current-Page Total Per-Page Link]
      end
    end

    config.assets.initialize_on_precompile = false

    config.middleware.use ActionDispatch::Cookies

    Rack::Attack.throttled_response = lambda do |env|
      match_data = env['rack.attack.match_data']
      now = match_data[:epoch_time]

      headers = {
        'RateLimit-Limit' => match_data[:limit].to_s,
        'RateLimit-Remaining' => '0',
        'RateLimit-Reset' => (now + (match_data[:period] - now % match_data[:period])).to_s
      }

      [429, headers, ["Throttled\n"]]
    end

    Rack::Attack.throttled_response_retry_after_header = true

    config.middleware.use Rack::Attack

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
