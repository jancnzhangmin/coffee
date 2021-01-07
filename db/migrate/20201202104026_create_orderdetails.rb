class CreateOrderdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :orderdetails do |t|
      t.bigint :product_id
      t.bigint :order_id
      t.float :number
      t.float :price
      t.index :product_id
      t.index :order_id

      t.timestamps
    end
  end
end
