class AddAftersaleidToAftersaleimg < ActiveRecord::Migration[6.0]
  def change
    add_column :aftersaleimgs, :aftersale_id, :bigint
  end
end
