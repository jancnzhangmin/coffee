class CreateBuycars < ActiveRecord::Migration[6.0]
  def change
    create_table :buycars do |t|
      t.bigint :product_id
      t.bigint :user_id
      t.float :number
      t.float :price
      t.index :product_id
      t.index :user_id

      t.timestamps
    end
  end
end
