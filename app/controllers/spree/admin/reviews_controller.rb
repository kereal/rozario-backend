module Spree
  module Admin
    class ReviewsController < ResourceController
      
      before_action :load_data, except: :index
      
      def new
      end

      private

      def collection
        params[:q] ||= {}
        params[:q][:s] ||= "created_at desc"
        @search = super.ransack(params[:q])
        @reviews = @search.result.page(params[:page]).per(params[:per_page])
      end

      def load_data
        #@reviews = Spree::Review.order(created_at: :desc)
      end

    end
  end
end