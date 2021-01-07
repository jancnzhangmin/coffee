class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.bigint :shop_id
      t.index :shop_id

      t.timestamps
    end
  end
end
