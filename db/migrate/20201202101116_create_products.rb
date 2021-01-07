class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :subname
      t.float :cost
      t.float :price
      t.integer :onsale
      t.text :content
      t.integer :salecount
      t.string :cover

      t.timestamps
    end
  end
end
