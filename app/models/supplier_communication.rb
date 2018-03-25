# encoding: UTF-8

class SupplierCommunication < ActiveRecord::Base
  belongs_to :enquiry
  belongs_to :food_partner

  def update_enquiry!
    return unless enquiry.status == EnquiryStatus::WAITING_ON_SUPPLIER
    return unless email_text.downcase.start_with? 'yes'
    EnquiryStatus.progress(enquiry)
  end
end
