class CreateAgentareas < ActiveRecord::Migration[6.0]
  def change
    create_table :agentareas do |t|
      t.string :province
      t.string :city
      t.string :district
      t.string :adcode
      t.integer :member

      t.timestamps
    end
  end
end
