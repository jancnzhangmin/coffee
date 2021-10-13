class CreateSinglediscounts < ActiveRecord::Migration[6.0]
  def change
    create_table :singlediscounts do |t|
      t.bigint :product_id
      t.string :name
      t.integer :buynumber
      t.float :discount
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.index :product_id

      t.timestamps
    end
  end
end
