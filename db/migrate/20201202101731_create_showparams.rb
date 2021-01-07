class CreateShowparams < ActiveRecord::Migration[6.0]
  def change
    create_table :showparams do |t|
      t.bigint :product_id
      t.string :showkey
      t.string :showvalue
      t.index :product_id

      t.timestamps
    end
  end
end
