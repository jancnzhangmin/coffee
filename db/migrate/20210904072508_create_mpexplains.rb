class CreateMpexplains < ActiveRecord::Migration[6.0]
  def change
    create_table :mpexplains do |t|
      t.string :title
      t.string :url
      t.bigint :corder

      t.timestamps
    end
  end
end
