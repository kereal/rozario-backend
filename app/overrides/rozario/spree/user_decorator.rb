module Rozario
  module Spree
    module UserDecorator

      def self.prepended(base)
        base.class_eval do
          validates :phone, uniqueness: true, allow_blank: true, format: { with: /\A\+[0-9]{11}\z/ }   # 2do: сделать крутую валидацию
          after_commit -> { confirm_by(:phone) }, if: :saved_change_to_phone?, on: [:create, :update]
          after_commit -> { confirm_by(:email) }, if: :saved_change_to_email?, on: [:create, :update]
        end
      end

      def confirm_by(method)
        if last_request_at.present? and last_request_at > Time.now - 1.minute
          errors.add(:confirmation_token, message: "Минимальный интервал между запросами — 1 минута")
          return
        end

        # 2do: сделать авточистку
        update(last_request_at: Time.now, confirmation_token: generate_code, perishable_token: SecureRandom.hex(24))
        puts " >> sending code by #{method}: #{confirmation_token}"
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
