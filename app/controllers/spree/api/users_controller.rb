module Spree
  module Api
    class UsersController < Spree::Api::BaseController
      skip_before_action :load_user, :authenticate_user

      # получаем мыло или номер телефона, отправляем смс или письмо и отдаем токен
      def request_auth
        user_params = params.require(:user).permit(:phone, :email)
        @user = Spree::User.find_or_create_by user_params
        @user.request_auth_by user_params.keys.first&.to_sym   # :phone || :email

        if @user.errors.any?
          respond_with @user
        else
          render json: @user, only: [:perishable_token]
        end
      end

      # получаем код и токен, отдаем ключ api
      def auth
        sleep 1.5
        auth_params = params.require(:user).permit(:confirmation_token, :perishable_token)
        return if auth_params != auth_params.reject { |_,val| !val.present? }

        @user = Spree::User.find_by! confirmation_token: auth_params[:confirmation_token], perishable_token: auth_params[:perishable_token]

        if @user.authenticate_by_code
          render json: @user, only: [:id, :email, :phone, :spree_api_key]
        else
          head :unauthorized
        end
      end

    end
  end
end