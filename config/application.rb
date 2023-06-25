require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Rozario
  class Application < Rails::Application
    
    config.load_defaults 7.0
    config.time_zone = "Europe/Moscow"
    config.i18n.available_locales = [:ru]
    config.i18n.default_locale = :ru

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      enable_starttls: true,
      address: "mail.netangels.ru",
      port: 587,
      authentication: "plain",
      user_name: "robot@rozariofl.ru",
      password: Rails.application.credentials.mail.password
    }

  end
end
