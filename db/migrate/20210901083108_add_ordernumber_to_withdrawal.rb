class AddOrdernumberToWithdrawal < ActiveRecord::Migration[6.0]
  def change
    add_column :withdrawals, :ordernumber, :string
  end
end
