class OldEnquiryRecord < ActiveRecord::Base
  scope :by_enquiry, lambda{|enquiry_id|
    where('? = enquiry_id', enquiry_id)
  }
end
