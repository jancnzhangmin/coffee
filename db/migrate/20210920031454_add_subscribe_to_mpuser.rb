class AddSubscribeToMpuser < ActiveRecord::Migration[6.0]
  def change
    add_column :mpusers, :subscribe, :integer
  end
end
