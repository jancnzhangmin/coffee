class CreateNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :notices do |t|
      t.string :title
      t.text :content
      t.integer :status
      t.datetime :begintime
      t.datetime :endtime

      t.timestamps
    end
  end
end
