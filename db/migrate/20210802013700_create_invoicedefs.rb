class CreateInvoicedefs < ActiveRecord::Migration[6.0]
  def change
    create_table :invoicedefs do |t|
      t.bigint :user_id
      t.string :name
      t.string :duty
      t.string :address
      t.string :tel
      t.string :bank
      t.string :account
      t.string :mail
      t.integer :invoicetype
      t.index :user_id

      t.timestamps
    end
  end
end
