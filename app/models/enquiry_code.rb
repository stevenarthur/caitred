class EnquiryCode < ActiveRecord::Base
  belongs_to :enquiry

  TYPES = {
    review: 'review'
  }
end
