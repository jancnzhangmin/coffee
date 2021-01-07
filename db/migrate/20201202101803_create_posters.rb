class CreatePosters < ActiveRecord::Migration[6.0]
  def change
    create_table :posters do |t|
      t.bigint :product_id
      t.string :poster
      t.text :content
      t.index :product_id

      t.timestamps
    end
  end
end
