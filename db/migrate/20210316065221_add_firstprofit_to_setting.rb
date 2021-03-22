class AddFirstprofitToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :firstprofit, :float
    add_column :settings, :secondprofit, :float
  end
end
