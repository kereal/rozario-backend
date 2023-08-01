class AddProfileFieldsToSpreeUsers < ActiveRecord::Migration[7.0]

  def change
    add_column :spree_users, :name, :string
    add_column :spree_users, :dob, :date
    add_column :spree_users, :notifications, :json
  end

end
