class CreateMpusers < ActiveRecord::Migration[6.0]
  def change
    create_table :mpusers do |t|
      t.string :openid
      t.string :unionid
      t.string :nickname
      t.string :headurl

      t.timestamps
    end
  end
end
