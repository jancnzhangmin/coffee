class CreateAgentareausers < ActiveRecord::Migration[6.0]
  def change
    create_table :agentareausers do |t|
      t.bigint :agentarea_id
      t.datetime :begintime
      t.datetime :endtime
      t.float :amount
      t.integer :paystatus
      t.index :agentarea_id

      t.timestamps
    end
  end
end
