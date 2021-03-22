class CreateExamines < ActiveRecord::Migration[6.0]
  def change
    create_table :examines do |t|
      t.bigint :agentlevel_id
      t.bigint :user_id
      t.datetime :examinedate
      t.integer :checkexamine
      t.index :agentlevel_id
      t.index :user_id

      t.timestamps
    end
  end
end
