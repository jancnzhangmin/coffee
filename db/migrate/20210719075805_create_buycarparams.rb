class CreateBuycarparams < ActiveRecord::Migration[6.0]
  def change
    create_table :buycarparams do |t|
      t.bigint :buycar_id
      t.string :buyparam
      t.bigint :buyparam_id
      t.string :buyparamvalue
      t.bigint :buyparamvalue_id
      t.index :buycar_id
      t.index :buyparam_id
      t.index :buyparamvalue_id

      t.timestamps
    end
  end
end
