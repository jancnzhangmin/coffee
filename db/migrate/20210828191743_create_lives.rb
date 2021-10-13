class CreateLives < ActiveRecord::Migration[6.0]
  def change
    create_table :lives do |t|
      t.integer :roomid
      t.integer :status

      t.timestamps
    end
  end
end
