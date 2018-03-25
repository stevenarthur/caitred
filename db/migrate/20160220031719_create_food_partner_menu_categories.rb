class CreateFoodPartnerMenuCategories < ActiveRecord::Migration
  def change
    create_table :menu_categories do |t|
      t.references :food_partner, index: true, foreign_key: true
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :sort_order, default: 99

      t.timestamps null: false
    end
  end
end
