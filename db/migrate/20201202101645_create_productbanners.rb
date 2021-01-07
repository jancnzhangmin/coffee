class CreateProductbanners < ActiveRecord::Migration[6.0]
  def change
    create_table :productbanners do |t|
      t.bigint :product_id
      t.string :banner
      t.bigint :corder
      t.index :product_id

      t.timestamps
    end
  end
end
