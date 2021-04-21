class CreateOrderdelivers < ActiveRecord::Migration[6.0]
  def change
    create_table :orderdelivers do |t|
      t.bigint :order_id
      t.string :com
      t.string :nu
      t.text :cdata
      t.string :company
      t.index :order_id

      t.timestamps
    end
  end
end
