class CreateLuckdraws < ActiveRecord::Migration[6.0]
  def change
    create_table :luckdraws do |t|
      t.string :name
      t.string :nametag
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.string :summary

      t.timestamps
    end
  end
end
