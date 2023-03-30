class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :spree_reviews do |t|
      
      t.integer :order_id, null: false, foreign_key: true
      t.string :text
      t.string :reply
      t.string :rating
      t.string :compliment
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
