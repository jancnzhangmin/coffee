class CreateLuckdrawpublics < ActiveRecord::Migration[6.0]
  def change
    create_table :luckdrawpublics do |t|
      t.string :summary

      t.timestamps
    end
  end
end
