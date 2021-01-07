class CreateJoinTableShopUser < ActiveRecord::Migration[6.0]
  def change
    create_join_table :shops, :users do |t|
      # t.index [:shop_id, :user_id]
      # t.index [:user_id, :shop_id]
    end
  end
end
