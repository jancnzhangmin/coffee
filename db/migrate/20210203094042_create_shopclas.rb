class CreateShopclas < ActiveRecord::Migration[6.0]
  def change
    create_table :shopclas do |t|
      t.string :name

      t.timestamps
    end
  end
end
