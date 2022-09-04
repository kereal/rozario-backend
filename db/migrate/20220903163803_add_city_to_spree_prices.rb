class AddCityToSpreePrices < ActiveRecord::Migration[7.0]
  def change
    add_column :spree_prices, :city, :string
  end
end
