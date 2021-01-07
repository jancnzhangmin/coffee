class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.string :login
      t.string :password_digest
      t.integer :status

      t.timestamps
    end
  end
end
