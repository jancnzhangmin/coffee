class CreateOrderinvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :orderinvoices do |t|
      t.bigint :order_id
      t.string :name
      t.string :duty
      t.string :address
      t.string :tel
      t.string :account
      t.string :mail
      t.integer :invoicetype
      t.index :order_id

      t.timestamps
    end
  end
end
