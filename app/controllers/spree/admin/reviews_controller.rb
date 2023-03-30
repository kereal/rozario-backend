module Spree
  module Admin
    class ReviewsController < ResourceController
      


      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "created_at desc"
        @search = super.ransack(params[:q])
        @search.result.page(params[:page]).per(params[:per_page]).order(params[:q][:s])
      end

    end
  end
end