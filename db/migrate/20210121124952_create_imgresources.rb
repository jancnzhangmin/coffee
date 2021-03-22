class CreateImgresources < ActiveRecord::Migration[6.0]
  def change
    create_table :imgresources do |t|
      t.string :img

      t.timestamps
    end
  end
end
