class CreateJoinTableProductProductcla < ActiveRecord::Migration[6.0]
  def change
    create_join_table :products, :productclas do |t|
      # t.index [:product_id, :productcla_id]
      # t.index [:productcla_id, :product_id]
    end
  end
end
