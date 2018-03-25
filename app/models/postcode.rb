class Postcode < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
	belongs_to :delivery_area

  has_many :food_partner_delivery_postcodes
  has_many :food_partners, through: :food_partner_delivery_postcodes

  def as_json options={}
    {
      'value': "#{title.titleize} - #{zipcode}",
      'data': slug
    }
  end

end
