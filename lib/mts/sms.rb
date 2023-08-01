module Mts
  class SMS

    def self.send(phone, text)
      payload = {
        messages: [{
        content: { short_text: text },
        from: { sms_address: "RozarioCvt" },
        to: [{ msisdn: phone }]
      }]}
  
      conn = Faraday.new(url: "https://omnichannel.mts.ru/http-api/v1/messages") do |f|
        f.request :authorization, :basic, Rails.application.credentials.sms.login, Rails.application.credentials.sms.password
      end
  
      response = conn.post("", payload.to_json, "Content-Type" => "application/json")
      message_id = JSON.parse(response.body)&.dig("messages")&.first&.dig("internal_id")
      
      if response.status == 200
        Rails.logger.info "SMS sent, internal_id: #{message_id}"
        return true
      else
        raise "SMS send error: #{response.body}"
      end
    end

    def get_info(id)
      conn = Faraday.new(url: "https://omnichannel.mts.ru/http-api/v1/messages/info") do |f|
        f.request :authorization, :basic, Rails.application.credentials.sms.login, Rails.application.credentials.sms.password
      end
      response = conn.post("", { int_ids: [id] }.to_json, "Content-Type" => "application/json")
      response.body if response.status == 200
    end

  end
end
