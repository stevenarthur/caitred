class Quote < ActiveRecord::Base

  belongs_to :food_partner

  default_scope { order('created_at DESC') } 

  validates :name, 
            :email, 
            :phone,
            :postcode, 
            :contact_method,
            :message, presence: true

end
