class DeliveryArea < ActiveRecord::Base
	has_and_belongs_to_many :food_partners
	has_many :postcodes

	scope :by_postcode, -> (postcode) { joins(:postcodes).where('postcodes.zipcode = ?', postcode) }
end
