class CreateAccesstokens < ActiveRecord::Migration[6.0]
  def change
    create_table :accesstokens do |t|
      t.string :accesstoken
      t.integer :expiresin

      t.timestamps
    end
  end
end
