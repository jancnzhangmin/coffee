class CreateBuyfullactivedetails < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfullactivedetails do |t|
      t.bigint :buyfullactive_id
      t.integer :buynumber
      t.integer :givenumber
      t.bigint :giveproduct_id
      t.index :buyfullactive_id

      t.timestamps
    end
  end
end
