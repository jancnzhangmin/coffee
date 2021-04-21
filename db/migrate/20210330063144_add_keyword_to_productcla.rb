class AddKeywordToProductcla < ActiveRecord::Migration[6.0]
  def change
    add_column :productclas, :keyword, :string
  end
end
