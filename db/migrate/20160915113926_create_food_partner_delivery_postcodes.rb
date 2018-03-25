class CreateFoodPartnerDeliveryPostcodes < ActiveRecord::Migration
  def change
    create_table :food_partner_delivery_postcodes do |t|
      t.references :food_partner, index: true, foreign_key: true, null: false
      t.references :postcode, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
