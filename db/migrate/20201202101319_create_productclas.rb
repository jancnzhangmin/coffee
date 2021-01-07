class CreateProductclas < ActiveRecord::Migration[6.0]
  def change
    create_table :productclas do |t|
      t.string :name
      t.bigint :corder
      t.integer :ispro

      t.timestamps
    end
  end
end
