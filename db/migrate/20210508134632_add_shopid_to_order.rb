class AddShopidToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :shop_id, :bigint
  end
end
