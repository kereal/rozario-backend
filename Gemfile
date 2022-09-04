source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.3", ">= 7.0.3.1"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", "~> 5.0"
gem "jbuilder"
gem "bootsnap", require: false           # Reduces boot times through caching; required in config/boot.rb
gem "solidus_i18n", "~> 2.0"
gem "rails-i18n"
gem "kaminari-i18n", "~> 0.5.0"
gem "bcrypt", "~> 3.1.7"
gem "solidus_auth_devise"
gem "solidus_core", "~> 3.2"
gem "solidus_backend", "~> 3.2"
gem "solidus_api", "~> 3.2"
gem "solidus_sample", "~> 3.2"
gem "canonical-rails"
gem "solidus_support"
gem "truncate_html"
gem "view_component", "~> 2.46"


# gem "redis", "~> 4.0"
# gem "kredis"
# Use Sass to process CSS
# gem "sassc-rails"
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  #gem "web-console"
  # gem "rack-mini-profiler"
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
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
