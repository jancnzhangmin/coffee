class CreateAreaamounts < ActiveRecord::Migration[6.0]
  def change
    create_table :areaamounts do |t|
      t.float :province
      t.float :city
      t.float :district

      t.timestamps
    end
  end
end
