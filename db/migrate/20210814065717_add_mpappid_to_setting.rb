class AddMpappidToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :mpappid, :string
    add_column :settings, :mpappsecret, :string
  end
end
