class AddSalesumToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :salesum, :float
    add_column :users, :salecount, :integer
    add_column :users, :peoplecount, :integer
    add_column :users, :mancount, :integer
    add_column :users, :directorcount, :integer
    add_column :users, :managercount, :integer
  end
end
