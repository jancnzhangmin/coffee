class AddResourceurlToResource < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :resourceurl, :string
  end
end
