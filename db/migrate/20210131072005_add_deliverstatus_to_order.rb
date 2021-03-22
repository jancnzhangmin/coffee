class AddDeliverstatusToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :deliverstatus, :integer
    add_column :orders, :paytime, :datetime
    add_column :orders, :receivetime, :datetime
    add_column :orders, :evaluatetime, :datetime
    add_column :orders, :amount, :float
  end
end
