class CreateContracttemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :contracttemplates do |t|
      t.string :contracttemplate

      t.timestamps
    end
  end
end
