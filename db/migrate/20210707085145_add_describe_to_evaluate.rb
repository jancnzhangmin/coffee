class AddDescribeToEvaluate < ActiveRecord::Migration[6.0]
  def change
    add_column :evaluates, :describe, :float
  end
end
