def ensure_food_partner(company_name)
  food_partner = FoodPartner.find_by_company_name(company_name)
  FactoryGirl.create(:food_partner, company_name: company_name) if food_partner.nil?
end

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize
def ensure_menu(properties, active)
  name = properties['Name']
  food_partner = FoodPartner.find_by_company_name(properties['Food Partner'])
  menu = Menu.by_partner_and_title(food_partner, name)
  FactoryGirl.create(
    :menu,
    food_partner: food_partner,
    title: name,
    event_type: [properties['Event Type']],
    active: active,
    minimum_attendees: properties['Minimum Attendees'].to_i,
    price: properties['Price'].to_i,
    tags: properties['Tags'].to_s.split(','),
    dietary_properties: properties['Dietary'].to_s.split(',')
  ) if menu.empty?
end
# rubocop:enable Metrics/MethodLength, Metrics/AbcSize

def ensure_packageable_item(title, food_partner_name, type)
  food_partner = FoodPartner.find_by_company_name(food_partner_name)
  packageable_item = PackageableItem.find_by_title(title)
  FactoryGirl.create(
    :packageable_item,
    food_partner: food_partner,
    title: title,
    item_type: type
  ) if packageable_item.nil?
end

def ensure_admin_user(username, password)
  admin_user = Authentication::AdminUser.find_by_username(username)
  admin_user = FactoryGirl.create(
    :admin_user,
    username: username
  ) if admin_user.nil?
  admin_user.update_attributes!(password: password, password_confirmation: password)
end

def ensure_named_admin_user(username, first_name, last_name)
  admin_user = Authentication::AdminUser.find_by_username(username)
  admin_user = FactoryGirl.create(
    :admin_user,
    username: username
  ) if admin_user.nil?
  admin_user.update_attributes!(first_name: first_name, last_name: last_name)
end

def ensure_named_power_user(username, first_name, last_name)
  admin_user = Authentication::AdminUser.find_by_username(username)
  admin_user = FactoryGirl.create(
    :admin_user,
    username: username
  ) if admin_user.nil?
  admin_user.update_attributes!(
    first_name: first_name,
    last_name: last_name,
    is_power_user: true
  )
end

def ensure_customer(email, first_name, last_name)
  customer = Customer.find_by_email(email)
  customer = FactoryGirl.create(
    :customer,
    email: email
  ) if customer.nil?
  customer.update_attributes!(
    first_name: first_name,
    last_name: last_name
  )
end

def create_menu_items(number_of_items)
  menu_items_array = []
  (1..number_of_items).each do
    menu_items_array.push(FactoryGirl.build(:menu_item).to_h)
  end
  FactoryGirl.build(:menu_items, items: menu_items_array)
end

def ensure_menu_with_items(menu_title, number_of_items)
  menu = Menu.find_by_title(menu_title) || FactoryGirl.create(:menu)
  menu_items = create_menu_items(number_of_items)
  menu.update_attributes(items: menu_items)
end

def ensure_menu_with_extra_items(menu_title, number_of_items)
  menu = Menu.find_by_title(menu_title) || FactoryGirl.create(:menu)
  menu_items = create_menu_items(number_of_items)
  menu.update_attributes(extras: menu_items)
end

def ensure_menu_with_equipment_items(menu_title, number_of_items)
  menu = Menu.find_by_title(menu_title) || FactoryGirl.create(:menu)
  menu_items = create_menu_items(number_of_items)
  menu.update_attributes(equipment_extras: menu_items)
end

def create_enquiry_for(email)
  customer = Customer.find_by_email(email)
  FactoryGirl.create(:enquiry, customer: customer)
end

def create_enquiry
  FactoryGirl.create(:enquiry)
end

def create_ready_to_confirm_enquiry(details)
  customer = Customer.find_by_email details['Customer']
  customer.addresses = [FactoryGirl.create(:address)]
  enquiry = FactoryGirl.create(
    :enquiry,
    customer: customer,
    event: create_event_details(details),
    menu_title: details['Menu Title'],
    customer_menu_content: details['Menu Contents'],
    payment_method: details['Payment Method']
  )
  enquiry.create_confirm_link(EnquiryStatus::READY_TO_CONFIRM)
end

def create_event_details(details)
  EventDetails.load(
    event_date: details['Event Date'],
    event_time: details['Event Time'],
    attendees: details['Attendees']
  )
end

def create_enquiry_with_status(status)
  FactoryGirl.create(:enquiry, status: status)
end

def create_completed_enquiry
  create_enquiry_with_status(EnquiryStatus::COMPLETED)
end

def ensure_menu_has_item(title, item_title)
  menu = Menu.find_by_title(title)
  item = PackageableItem.find_by_title(item_title)
  menu.add_item(item)
end

def ensure_menu_has_extra_item(title, item_title)
  menu = Menu.find_by_title(title)
  item = PackageableItem.find_by_title(item_title)
  menu.add_extra_item(item)
end

def ensure_customer_has_address(email, line_1, suburb, postcode)
  customer = Customer.find_by_email(email)
  FactoryGirl.create(
    :address,
    line_1: line_1,
    suburb: suburb,
    postcode: postcode,
    customer: customer
  )
end

def ensure_customer_user(email, password, first_name, last_name)
  FactoryGirl.create(
    :customer,
    email: email,
    password: password,
    password_confirmation: password,
    first_name: first_name,
    last_name: last_name
  )
end

def ensure_poll(title, answers)
  poll = FactoryGirl.create(:poll, title: title)
  answers.each do |answer|
    answer_text = answer['Answer Text']
    order = answer['Order']
    id = answer['ID']
    FactoryGirl.create(:poll_answer, id: id, poll: poll, answer_text: answer_text, order: order)
  end
end

def ensure_menu_filter(filter_name)
  tag = MenuTag.find_by_tag(filter_name) ||
        FactoryGirl.create(:menu_tag, tag: filter_name)

  tag.update_attributes! is_filter: true
end
