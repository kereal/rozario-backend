require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Rozario
  class Application < Rails::Application
    
    config.load_defaults 7.0
    config.time_zone = "Europe/Moscow"
    config.i18n.available_locales = [:ru]
    config.i18n.default_locale = :ru
    
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
