class CreateJobmonitors < ActiveRecord::Migration[6.0]
  def change
    create_table :jobmonitors do |t|
      t.string :name
      t.string :param

      t.timestamps
    end
  end
end
