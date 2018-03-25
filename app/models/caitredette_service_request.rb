class CaitredetteServiceRequest < ActiveRecord::Base
  validates :name,
            :postcode,
            :email,
            :phone,
            :message, presence: true
end
