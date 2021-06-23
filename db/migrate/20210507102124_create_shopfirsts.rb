class CreateShopfirsts < ActiveRecord::Migration[6.0]
  def change
    create_table :shopfirsts do |t|
      t.string :name
      t.datetime :begintime
      t.datetime :endtime
      t.integer :status
      t.string :summary

      t.timestamps
    end
  end
end
