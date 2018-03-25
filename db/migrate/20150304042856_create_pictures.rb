class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string  :name
      t.boolean :cover
      t.string :alt_text
      t.references :imageable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
