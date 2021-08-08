class CreateOrderdetailparams < ActiveRecord::Migration[6.0]
  def change
    create_table :orderdetailparams do |t|
      t.bigint :orderdetail_id
      t.string :buyparam
      t.bigint :buyparam_id
      t.string :buyparamvalue
      t.bigint :buyparamvalue_id
      t.index :orderdetail_id

      t.timestamps
    end
  end
end
