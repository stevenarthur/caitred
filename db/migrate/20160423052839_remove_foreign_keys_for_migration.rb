class RemoveForeignKeysForMigration < ActiveRecord::Migration

  def up 
    # Food Partners
    remove_foreign_key :enquiries, name: "enquiries_food_artisan_id_fk"
    remove_foreign_key :menus, name: "menus_food_artisan_id_fk"
    remove_foreign_key :requests, name: "orders_food_artisan_id_fk"
    remove_foreign_key :packageable_items, name: "packageable_items_food_artisan_id_fk"
    remove_foreign_key :supplier_communications, name: "supplier_enquiries_food_artisan_id_fk"
    remove_foreign_key :menu_categories, name: "fk_rails_dc1af18ba5"

    # Packageable Items
    remove_foreign_key :enquiry_items, name: 'fk_rails_a2c884121f'
    remove_foreign_key :menu_packages, name: 'menu_packages_packageable_item_id_fk'
  end

  def down
    add_foreign_key :enquiries, :food_partners, name: "enquiries_food_artisan_id_fk" 
    add_foreign_key :menus, :food_partners, name: "menus_food_artisan_id_fk"
    add_foreign_key :requests, :food_partners, name: "orders_food_artisan_id_fk"
    add_foreign_key :pageable_items, :food_partners, name: "packageable_items_food_artisan_id_fk"
    add_foreign_key :supplier_communications, :food_partners, name: "supplier_enquiries_food_artisan_id_fk"
    add_foreign_key :menu_categories, :food_partners, name: "fk_rails_dc1af18ba5"

    add_foreign_key :enquiry_items, :packageable_items, name: 'fk_rails_a2c884121f'
    add_foreign_key :menu_packages, :packageable_items, name: 'menu_packages_packageable_item_id_fk'
  end

end
