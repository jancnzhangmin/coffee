class AddProducttypeToBuycar < ActiveRecord::Migration[6.0]
  def change
    add_column :buycars, :producttype, :integer
    add_column :buycars, :activesummary, :string
  end
end
