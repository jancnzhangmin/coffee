class CreateBuyparamvalues < ActiveRecord::Migration[6.0]
  def change
    create_table :buyparamvalues do |t|
      t.bigint :buyparam_id
      t.string :cover
      t.string :name
      t.float :price
      t.index :buyparam_id

      t.timestamps
    end
  end
end
