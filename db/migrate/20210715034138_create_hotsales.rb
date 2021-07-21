class CreateHotsales < ActiveRecord::Migration[6.0]
  def change
    create_table :hotsales do |t|
      t.bigint :product_id
      t.bigint :corder
      t.index :product_id

      t.timestamps
    end
  end
end
