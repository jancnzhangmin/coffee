class AddQrcodeToSetting < ActiveRecord::Migration[6.0]
  def change
    add_column :settings, :qrcode, :string
  end
end
