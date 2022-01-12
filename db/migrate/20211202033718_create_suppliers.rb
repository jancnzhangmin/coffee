class CreateSuppliers < ActiveRecord::Migration[6.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :contact
      t.string :address
      t.string :tel
      t.string :invoicename
      t.string :invoiceduty
      t.string :invoiceaddress
      t.string :invoicetel
      t.string :invoicebank
      t.string :invoiceaccount
      t.float :firstorder
      t.float :renewalorder

      t.timestamps
    end
  end
end
