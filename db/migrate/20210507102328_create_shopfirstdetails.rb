class CreateShopfirstdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :shopfirstdetails do |t|
      t.bigint :shopfirst_id
      t.bigint :buyproduct_id
      t.integer :buynumber
      t.bigint :giveproduct_id
      t.integer :givenumber
      t.index :shopfirst_id

      t.timestamps
    end
  end
end
