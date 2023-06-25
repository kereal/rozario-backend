module Rozario
  module Spree
    module UserDecorator
      
      def self.prepended(base)
        base.class_eval do
          def self.confirmation_token_lifetime
            1.hour
          end
          validates :phone, uniqueness: true, allow_blank: true, format: { with: /\A\+[0-9]{11}\z/ }
          after_commit -> { request_auth_by(:phone) }, if: :saved_change_to_phone?, on: [:create, :update]
          after_commit -> { request_auth_by(:email) }, if: :saved_change_to_email?, on: [:create, :update]
        end
      end

      def request_auth_by(method)
        interval = 1.minute
        if last_request_at.present? and last_request_at > Time.now - interval
          errors.add(:confirmation_token, message: "Минимальный интервал между запросами — #{interval.in_seconds} с")
          return
        end

        update(last_request_at: Time.now, confirmation_token: generate_code, perishable_token: SecureRandom.hex(24))

        if method == :phone
          unless Rails.env == "development"
            SendSmsJob.perform_later phone, "Код для входа: #{confirmation_token}"
          end
        end

        if method == :email
          unless Rails.env == "development"
            ::Spree::UserMailer.with(user: self).request_auth.deliver_later
          end
        end

        puts ">> send code by #{method}: #{confirmation_token}" if Rails.env == "development"
      end

      def authenticate_by_code
        return false if last_request_at && last_request_at < Time.now - self.class.confirmation_token_lifetime
        update(confirmed_at: Time.now, confirmation_token: nil, perishable_token: nil)
      end

      protected

      def email_required?
        phone.present? ? false : super
      end

      def password_required?
        false
      end

      def generate_code # 4 цифры
        begin
          code = '%04d' % Random.rand(2..9999)
        end while self.class.exists?(confirmation_token: code)
        code
      end

     
      ::Spree::User.prepend(self) if ::Spree::User.included_modules.exclude?(self)
    
    end
  end
end


# Spree::User.class_eval do
#   # code
# end

# https://dev-docs.spreecommerce.org/customization/logic
# https://guides.solidus.io/customization/customizing-the-core
