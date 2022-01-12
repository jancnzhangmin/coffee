class CreateGiftdepots < ActiveRecord::Migration[6.0]
  def change
    create_table :giftdepots do |t|
      t.bigint :user_id
      t.bigint :product_id
      t.integer :number
      t.integer :expireday
      t.integer :deletestatus
      t.integer :usedstatus
      t.bigint :appointproduct_id
      t.index :user_id
      t.index :product_id
      t.index :appointproduct_id

      t.timestamps
    end
  end
end
