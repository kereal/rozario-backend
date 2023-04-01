class ApplicationController < ActionController::Base

  include ActiveStorage::SetCurrent

  before_action do
    if Rails.env.production?
      ActiveStorage::Current.host = 'http://new.rozarioflowers.ru'
    end
  end

end
