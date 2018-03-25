def get_enquiries_for_customer(first_name, last_name)
  customer = Customer.by_name(first_name, last_name).first
  customer.enquiries
end

def find_admin_user(username)
  Authentication::AdminUser.find_by_username(username)
end

def find_enquiry(id)
  Enquiry.find id
end

def total_number_of_enquiries
  Enquiry.all.size
end

def food_partner_exists?(company_name)
  !find_food_partner(company_name).nil?
end

def menu_exists?(company_name, menu_title)
  food_partner = FoodPartner.find_by_company_name(company_name)
  Menu.by_partner_and_title(food_partner.id, menu_title).size == 1
end

def find_menu(menu_title)
  Menu.find_by_title(menu_title)
end

def find_food_partner(company_name)
  FoodPartner.find_by_company_name(company_name)
end

def find_food_partner_contact_name(company_name)
  food_partner = find_food_partner(company_name)
  "#{food_partner.contact_first_name} #{food_partner.contact_last_name}"
end

def find_item_by_food_partner_and_title(food_partner_name, item_title)
  food_partner = find_food_partner(food_partner_name)
  PackageableItem.by_food_partner(food_partner).with_title(item_title).first
end

def find_item_by_title(item_title)
  PackageableItem.with_title(item_title).first
end

def count_of_menu_items(menu_title)
  menu = Menu.find_by_title(menu_title)
  menu.packageable_items.food.included.size
end

def count_of_extra_food_items(menu_title)
  menu = Menu.find_by_title(menu_title)
  menu.packageable_items.food.extras.size
end

def count_of_equipment_items(menu_title)
  menu = Menu.find_by_title(menu_title)
  menu.packageable_items.equipment.extras.size
end

def menu_cost(menu_title)
  menu = Menu.find_by_title(menu_title)
  menu.price_string
end

def poll_count
  Poll.all.size
end

def find_poll(title)
  Poll.find_by_title(title)
end
