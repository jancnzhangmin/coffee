class CreateShopimgs < ActiveRecord::Migration[6.0]
  def change
    create_table :shopimgs do |t|
      t.bigint :shop_id
      t.string :shopimg
      t.integer :iscover
      t.index :shop_id

      t.timestamps
    end
  end
end
