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

    config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      tls: true,
      address: 'smtp.yandex.ru',
      port: 465,
      domain: 'kereal.ru',
      authentication: 'plain',
      user_name: 'bender@kereal.ru',
      password: 'Ilovebender'
    }
    
    # config.eager_load_paths << Rails.root.join("extras")
  end

end
