class Review < ApplicationRecord
  
  belongs_to :order, class_name: 'Spree::Order'#, foreign_key: :order_id
  has_one :user, through: :order, class_name: 'Spree::User'
  
  validates :text, presence: true
  
  scope :published, -> { where(published: true) }
  
end
