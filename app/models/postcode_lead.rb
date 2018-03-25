class PostcodeLead < ActiveRecord::Base
  validates :email, :postcode, presence: true
end
