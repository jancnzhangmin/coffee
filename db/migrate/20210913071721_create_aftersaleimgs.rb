class CreateAftersaleimgs < ActiveRecord::Migration[6.0]
  def change
    create_table :aftersaleimgs do |t|
      t.bigint :aftersaleimg_id
      t.string :aftersaleimg
      t.index :aftersaleimg_id

      t.timestamps
    end
  end
end
