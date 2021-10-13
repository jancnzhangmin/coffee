class CreateAftersales < ActiveRecord::Migration[6.0]
  def change
    create_table :aftersales do |t|
      t.bigint :order_id
      t.string :contact
      t.string :summary
      t.string :reply
      t.index :order_id

      t.timestamps
    end
  end
end
