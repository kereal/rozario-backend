source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.1"

gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "sqlite3", "~> 1.4"
gem "pg"
gem "puma", "~> 5.0"
gem "sprockets-rails"
gem "jbuilder"
gem "bootsnap", require: false           # Reduces boot times through caching; required in config/boot.rb
gem "rails-i18n"
gem "kaminari-i18n", "~> 0.5.0"
gem "bcrypt", "~> 3.1.7"
gem "solidus_i18n", "~> 2.0"
gem "solidus_auth_devise"
gem "solidus_core", "~> 3.2"
gem "solidus_backend", "~> 3.2"
gem "solidus_api", "~> 3.2"
gem "solidus_support"
gem "canonical-rails"
gem "truncate_html"
gem "view_component", "~> 2.46"
gem "image_processing", "~> 1.2"


group :development do
  gem "pry-rails"
  # gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
  # gem "rails_real_favicon"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development, :test do
  gem "rspec-rails"
  gem "apparition", "~> 0.6.0", github: "twalpole/apparition"
  gem "rails-controller-testing", "~> 1.0.5"
  gem "rspec-activemodel-mocks", "~> 1.1.0"
  gem "solidus_dev_support", "~> 2.5"
end

group :production do
  gem "sd_notify"
  gem "lograge"
end