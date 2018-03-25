require "rails_helper"

RSpec.describe ProcessNewSupplierEnquiryJob, type: :job do
  
  let(:enquiry_params){ { name: 'paul', email: 'paul@millar.net', phone: '0425616398', 
                          company_name: 'digital dawn', more_info: 'this is a test message',
                          website: 'facebook.com/digitaldawn', cuisine: 'italian',
                          delivery: 'yes' } }

  pending "checks correctly for spam" do
    expect(
      ProcessNewSupplierEnquiryJob.perform_now('192.168.0.1', 'chrome', enquiry_params)
    ).to eq ""
  end

end
