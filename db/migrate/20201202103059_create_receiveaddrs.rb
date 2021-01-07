class CreateReceiveaddrs < ActiveRecord::Migration[6.0]
  def change
    create_table :receiveaddrs do |t|
      t.bigint :user_id
      t.string :province
      t.string :city
      t.string :district
      t.string :adcode
      t.string :address
      t.integer :isdefault
      t.string :contact
      t.string :contactphone
      t.index :user_id

      t.timestamps
    end
  end
end
