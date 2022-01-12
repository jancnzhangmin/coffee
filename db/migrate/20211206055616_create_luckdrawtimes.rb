class CreateLuckdrawtimes < ActiveRecord::Migration[6.0]
  def change
    create_table :luckdrawtimes do |t|
      t.bigint :user_id
      t.bigint :luckdrawtime_id
      t.datetime :begintime
      t.datetime :endtime
      t.integer :times
      t.integer :systemgive
      t.index :user_id
      t.index :luckdrawtime_id

      t.timestamps
    end
  end
end
