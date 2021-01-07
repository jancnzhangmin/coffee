class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :openid
      t.string :unionid
      t.string :nickname
      t.bigint :up_id
      t.decimal :lng, precision:15, scale: 12
      t.decimal :lat, precision:15, scale: 12
      t.index :up_id

      t.timestamps
    end
  end
end
