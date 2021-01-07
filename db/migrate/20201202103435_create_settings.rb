class CreateSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :settings do |t|
      t.string :appid
      t.string :appsecret

      t.timestamps
    end
  end
end
