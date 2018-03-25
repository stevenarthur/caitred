class FoodPartnerDeliveryPostcode < ActiveRecord::Base
  belongs_to :food_partner
  belongs_to :postcode

  validates :food_partner_id, 
            :postcode_id, presence: true
end
