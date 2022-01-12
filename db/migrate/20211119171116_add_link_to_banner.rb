class AddLinkToBanner < ActiveRecord::Migration[6.0]
  def change
    add_column :banners, :link, :string
  end
end
