class CreatePopmsgs < ActiveRecord::Migration[6.0]
  def change
    create_table :popmsgs do |t|
      t.bigint :user_id
      t.datetime :poptime
      t.index :user_id

      t.timestamps
    end
  end
end
