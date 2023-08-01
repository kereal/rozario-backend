module Rozario
  module Spree
    module UserDecorator
      
      # можно перенести include Spree::UserMethods
      # https://guides.solidus.io/advanced-solidus/custom-authentication

      def self.prepended(base)
        base.class_eval do
          def self.confirmation_token_lifetime
            1.hour
          end
          validates :phone, uniqueness: true, allow_blank: true, format: { with: /\A\+[0-9]{11}\z/ }
          after_commit -> { request_auth_by(:phone) }, if: :saved_change_to_phone?, on: [:create, :update]
          after_commit -> { request_auth_by(:email) }, if: :saved_change_to_email?, on: [:create, :update]

          validate :validate_avatar
          has_one_attached :avatar do |attachable|
            attachable.variant :mini, resize_to_limit: [48, 48]
            attachable.variant :normal, resize_to_limit: [132, 132]
            attachable.variant :large, resize_to_limit: [320, 320]
          end
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
          SendSmsJob.perform_later phone, "Код для входа: #{confirmation_token}" unless Rails.env == "development"
        end

        if method == :email
          ::Spree::UserMailer.with(user: self).request_auth.deliver_later unless Rails.env == "development"
        end

        puts ">> send code by #{method}: #{confirmation_token}" if Rails.env == "development"
      end

      def authenticate_by_code
        return false if last_request_at && last_request_at < Time.now - self.class.confirmation_token_lifetime
        update(confirmed_at: Time.now, confirmation_token: nil, perishable_token: nil)
      end

      def avatar_url
        avatar.url
      end

      def dob
        I18n.l attributes["dob"]
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

      def validate_avatar
        return unless avatar.attached?
        if avatar.image?
          unless avatar.content_type.in?(::Spree::Config.allowed_image_mime_types)
            errors.add(:avatar, :content_type_not_supported)
          end
        else
          errors.add(:avatar, "не является изображением")
        end
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
