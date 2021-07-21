class AddAutoreceiveToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :autoreceive, :integer
    add_column :settings, :autoevaluate, :integer
  end
end
