class CreateAppointproductdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :appointproductdetails do |t|
      t.bigint :appointproduct_id
      t.integer :number
      t.bigint :product_id

      t.timestamps
      t.index :appointproduct_id
      t.index :product_id
    end
  end
end
