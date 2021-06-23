class AddShopdefaultidToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :shopdefaultid, :bigint
  end
end
