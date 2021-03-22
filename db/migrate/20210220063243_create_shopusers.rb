class CreateShopusers < ActiveRecord::Migration[6.0]
  def change
    create_table :shopusers do |t|
      t.bigint :shop_id
      t.bigint :user_id
      t.integer :member
      t.index :shop_id
      t.index :user_id

      t.timestamps
    end
  end
end
