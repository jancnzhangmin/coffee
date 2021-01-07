class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.bigint :user_id
      t.string :ordernumber
      t.string :contact
      t.string :contactphone
      t.string :province
      t.string :city
      t.string :district
      t.string :adcode
      t.string :address
      t.integer :paystatus
      t.integer :receivestatus
      t.integer :evaluatestatus
      t.string :summary
      t.integer :afterstatus
      t.index :user_id

      t.timestamps
    end
  end
end
