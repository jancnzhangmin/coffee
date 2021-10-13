class CreateMpmaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :mpmaterials do |t|
      t.string :mediaid
      t.string :title
      t.string :url
      t.index :mediaid

      t.timestamps
    end
  end
end
