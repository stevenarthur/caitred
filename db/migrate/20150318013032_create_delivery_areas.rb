class CreateDeliveryAreas < ActiveRecord::Migration
  def change
    create_table :delivery_areas do |t|
      t.string :title

      t.timestamps
    end

    create_table :delivery_areas_food_partners do |t|
      t.belongs_to :food_partner
      t.belongs_to :delivery_area

      t.timestamps
    end
   
  end
end
