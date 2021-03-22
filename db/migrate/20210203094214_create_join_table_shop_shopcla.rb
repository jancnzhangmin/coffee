class CreateJoinTableShopShopcla < ActiveRecord::Migration[6.0]
  def change
    create_join_table :shops, :shopclas do |t|
      # t.index [:shop_id, :shopcla_id]
      # t.index [:shopcla_id, :shop_id]
    end
  end
end
