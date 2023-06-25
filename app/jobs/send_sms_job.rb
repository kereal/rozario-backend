require "mts/sms.rb"

class SendSmsJob < ApplicationJob
  
  queue_as :default

  def perform(phone, text)
    Mts::SMS.send_sms(phone, text)
  end

end
