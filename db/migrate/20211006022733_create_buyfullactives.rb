class CreateBuyfullactives < ActiveRecord::Migration[6.0]
  def change
    create_table :buyfullactives do |t|
      t.string :name
      t.string :nametag
      t.datetime :begintime
      t.datetime :endtime
      t.string :summary
      t.string :cover
      t.float :price
      t.bigint :product_id
      t.integer :status

      t.timestamps
    end
  end
end
