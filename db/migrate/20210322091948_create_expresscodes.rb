class CreateExpresscodes < ActiveRecord::Migration[6.0]
  def change
    create_table :expresscodes do |t|
      t.string :name
      t.string :comcode

      t.timestamps
    end
  end
end
