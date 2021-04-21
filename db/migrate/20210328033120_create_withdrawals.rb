class CreateWithdrawals < ActiveRecord::Migration[6.0]
  def change
    create_table :withdrawals do |t|
      t.bigint :user_id
      t.float :amount
      t.integer :status
      t.index :user_id

      t.timestamps
    end
  end
end
