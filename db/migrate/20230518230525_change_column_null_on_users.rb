class ChangeColumnNullOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_null :spree_users, :email, true
  end
end
