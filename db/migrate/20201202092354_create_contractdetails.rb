class CreateContractdetails < ActiveRecord::Migration[6.0]
  def change
    create_table :contractdetails do |t|
      t.bigint :contract_id
      t.string :contract
      t.index :contract_id

      t.timestamps
    end
  end
end
