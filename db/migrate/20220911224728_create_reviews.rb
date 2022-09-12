class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      
      t.integer :order_id, null: false, foreign_key: true
      t.string :text
      t.string :reply
      t.float :freshness
      t.float :delivery
      t.float :service
      t.string :compliment
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
