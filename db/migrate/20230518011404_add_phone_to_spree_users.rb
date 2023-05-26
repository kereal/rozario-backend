class AddPhoneToSpreeUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_users, :phone, :string
    add_index :spree_users, :phone
  end
end
