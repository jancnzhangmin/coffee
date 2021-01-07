class CreateShops < ActiveRecord::Migration[6.0]
  def change
    create_table :shops do |t|
      t.string :name
      t.decimal :lng, precision:15, scale: 12
      t.decimal :lat, precision:15, scale: 12
      t.string :province
      t.string :city
      t.string :district
      t.string :address
      t.string :adcode

      t.timestamps
    end
  end
end
