class AddSystemstatusToEvaluate < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluates, :systemstatus, :integer
  end
end
