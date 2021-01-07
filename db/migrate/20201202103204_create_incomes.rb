class CreateIncomes < ActiveRecord::Migration[6.0]
  def change
    create_table :incomes do |t|
      t.bigint :user_id
      t.float :amount
      t.string :ordernumber
      t.integer :status
      t.string :summary
      t.index :user_id

      t.timestamps
    end
  end
end
