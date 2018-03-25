FactoryGirl.define do

  sequence :url_slug do |n|
    "url#{n}"
  end

  sequence :email do |n|
    "email#{n}@blah.com"
  end

  sequence :email_address do |n|
    "adminuser#{n}@blah.com"
  end

  sequence :username do |n|
    "testuser#{n}"
  end

  sequence :code do |n|
    "123#{n}"
  end

  factory :customer do
    email
    first_name 'first'
    last_name 'first'
    company_name 'example_company'
    telephone '0123 456 789'
    password 'password'
  end

  factory :address do
    line_1 'blah'
    company "Facebook"
    suburb "Randwick"
    postcode "2000"
    parking_information "Parking information here"
    default false
  end

  factory :enquiry do
    customer
    address
    event EventDetails.load format: '', type: '', event_date: '', event_time: ''
    status EnquiryStatus::NEW
    payment_method PaymentMethod::CREDIT_CARD.to_s
  end

  factory :enquiry_code do
    code
    enquiry
    code_type 'test'
  end

  factory :menu_tag do
    tag 'something'
  end

  factory :packageable_item do
    title 'An Item'
    cost 0
    food_partner
    item_type 'food'

    factory :food_item do
      item_type 'food'
    end

    factory :equipment_item do
      item_type 'equipment'
    end

    factory :vegan_item do
      item_type 'food'
      vegetarian true
      vegan true
    end

    factory :meat_item do
      item_type 'food'
      vegetarian false
      vegan false
    end

    factory :gf_item do
      item_type 'food'
      gluten_free true
    end

    factory :non_gf_item do
      item_type 'food'
      gluten_free false
    end
  end

  factory :menu_item do
    initialize_with { new(title: 'some food', price: 0) }
  end

  factory :menu_items do
    items []
    initialize_with { new(items: items) }
  end

  factory :food_partner do
    url_slug
    email
    contact_first_name 'John'
    contact_last_name 'Smith'
    minimum_attendees 1
    maximum_attendees 500

    factory :with_items do
      after(:create) do |menu|
      end
    end
  end

  factory :supplier_enquiry do
    food_partner
    enquiry
  end

  factory :supplier_communication do
    from_name 'testing'
    from_email 'test@test.com'
    to_name 'testing'
    to_email 'test@test.com'
    food_partner
    enquiry
  end

  factory :admin_user, class: Authentication::AdminUser do
    username
    mobile_number '1234'
    password 'password'
    password_confirmation 'password'
    email_address
    first_name 'test'
    last_name 'user'
    is_power_user false
  end

  factory :poll do
    id { SecureRandom.uuid }
    title 'survey'
    description_html 'about something'

    factory :poll_with_answers do
      after(:create) do |poll|
        create(:poll_answer, poll: poll)
      end
    end
  end

  factory :poll_answer do
    id { SecureRandom.uuid }
    answer_text 'yes'
    order 1
  end

  factory :poll_vote do
    id { SecureRandom.uuid }
    poll_answer
  end
end
