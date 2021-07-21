class AddDelivertimeToOrder < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :delivertime, :datetime
  end
end
