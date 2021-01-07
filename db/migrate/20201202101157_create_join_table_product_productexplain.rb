class CreateJoinTableProductProductexplain < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :productexplains do |t|
      # t.index [:product_id, :productexplain_id]
      # t.index [:productexplain_id, :product_id]
    end
  end
end
