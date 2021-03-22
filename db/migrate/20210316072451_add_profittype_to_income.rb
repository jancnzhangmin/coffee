class AddProfittypeToIncome < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :profittype, :string
  end
end
