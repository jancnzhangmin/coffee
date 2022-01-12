class CreateAppointproducts < ActiveRecord::Migration[6.0]
  def change
    create_table :appointproducts do |t|
      t.string :name

      t.timestamps
    end
  end
end
