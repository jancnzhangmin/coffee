class CreateInvitationgifts < ActiveRecord::Migration[6.0]
  def change
    create_table :invitationgifts do |t|
      t.string :name
      t.string :nametag
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.string :cover
      t.text :summary
      t.bigint :product_id
      t.bigint :appointproduct_id
      t.index :product_id
      t.index :appointproduct_id

      t.timestamps
    end
  end
end
