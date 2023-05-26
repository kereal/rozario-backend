module Spree
  module Api
    class UsersController < Spree::Api::BaseController
      skip_before_action :load_user, :authenticate_user


      # получаем мыло или номер телефона, отправляем смс или письмо и токен
      def request_auth
        @user = Spree::User.find_or_create_by user_params
        @user.confirm_by user_params.keys.first

        if @user.errors.any?
          respond_with @user
        else
          render json: @user, only: [:perishable_token]
        end
      end


      # получаем код и токен, отдаем ключ api
      def auth
        @user = Spree::User.find_by! confirmation_token: user_params[:confirmation_token], perishable_token: user_params[:perishable_token]

        if @user.last_request_at < Time.now - 30.minutes # код работает только 30 мин
          head :unauthorized
        else
          @user.update(confirmed_at: Time.now)
          render json: @user, only: [:id, :email, :phone, :spree_api_key]
        end

        @user.update(confirmation_token: nil, perishable_token: nil)
        # birthday name ava json:notifications: [push, sms, email]
        # docker compose exec app rails db:create
        # cat rdev.sql | docker exec -i rozario-db psql -U rozario -d rozario_development
      end


      private

      def user_params
        params.require(:user).permit(:phone, :email, :confirmation_token, :perishable_token)
      end

    end
  end
end