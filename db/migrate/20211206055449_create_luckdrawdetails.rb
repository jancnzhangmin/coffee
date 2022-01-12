class CreateLuckdrawdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :luckdrawdetails do |t|
      t.bigint :luckdraw_id
      t.bigint :product_id
      t.integer :number
      t.float :hitrate
      t.integer :thank
      t.integer :givenumber
      t.bigint :appointproduct_id
      t.index :luckdraw_id
      t.index :product_id
      t.index :appointproduct_id

      t.timestamps
    end
  end
end
