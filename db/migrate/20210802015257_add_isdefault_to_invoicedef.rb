class AddIsdefaultToInvoicedef < ActiveRecord::Migration[6.0]
  def change
    add_column :invoicedefs, :isdefault, :integer
  end
end
