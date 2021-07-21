class CreateBuyparams < ActiveRecord::Migration[6.0]
  def change
    create_table :buyparams do |t|
      t.bigint :product_id
      t.string :param
      t.index :product_id

      t.timestamps
    end
  end
end
