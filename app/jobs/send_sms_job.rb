require "mts/sms.rb"

class SendSmsJob < ApplicationJob
  
  queue_as :default

  def perform(phone, text)
    Mts::SMS.send(phone, text)
  end

end
