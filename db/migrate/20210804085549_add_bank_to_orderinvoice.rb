class AddBankToOrderinvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :orderinvoices, :bank, :string
  end
end
