module Factories
  class EnquiryFactory
    ALLOWED_PARAMS = [
      :customer_id,
      :source,
      :terms_accepted,
      :additional_messages,
      :total_cost,
      :price_per_head,
      :delivery_cost,
      :food_cost_to_us,
      :delivery_cost_to_us,
      :total_cost_to_us,
      :menu_content,
      :customer_menu_content,
      :food_partner_id,
      :menu_title,
      :total_amount_paid,
      :payment_fee_paid,
      :payment_method,
      :number_of_attendees,
      :paid,
      :stripe_card_token,
      :event_time,
      :event_date,
      { logistics: Logistics.allowed_params },
      { dietary_requirements: DietaryRequirements.allowed_params }
    ]

    # TODO: add methods to create / update customers here
    # and remove from controllers
  end
end
