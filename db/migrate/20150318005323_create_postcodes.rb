class CreatePostcodes < ActiveRecord::Migration
  def change
    create_table :postcodes do |t|
      t.string :zipcode
      t.string :title
      t.string :state
      t.string :country
      t.integer :delivery_area_id

      t.timestamps
    end

    add_index :postcodes, :delivery_area_id

  end
end
