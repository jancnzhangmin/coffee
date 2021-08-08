class AddProcessedToOrderinvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :orderinvoices, :processed, :integer
  end
end
