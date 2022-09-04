require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rozario
  
  class Application < Rails::Application
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.time_zone = "Europe/Moscow"
    config.i18n.available_locales = [:ru]
    config.i18n.default_locale = :ru

    # config.eager_load_paths << Rails.root.join("extras")
  end

end
