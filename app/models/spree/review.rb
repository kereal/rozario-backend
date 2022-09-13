# frozen_string_literal: true

module Spree
  class Review < Spree::Base
  
    belongs_to :order
    has_one :user, through: :order
    
    validates :text, presence: true
    
    scope :published, -> { where(published: true).order(created_at: :desc) }
    
    serialize :rating
    serialize :compliment
    
    
    def publish!
      update(published: true)
    end

  end
end
