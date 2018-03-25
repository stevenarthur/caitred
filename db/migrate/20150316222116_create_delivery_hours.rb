class CreateDeliveryHours < ActiveRecord::Migration
  def change
    create_table :delivery_hours do |t|
      t.time :hour_start
      t.time :hour_end
      t.belongs_to :food_partner

      t.timestamps
    end

    add_index :delivery_hours, :food_partner_id
  end
end
