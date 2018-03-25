require 'rails_helper'

describe CustomerReport do
  let(:now) { Time.parse('19 Jan 2016 12:00') }
  let(:weekly_customer) { create(:customer) }
  let(:regular_customer) { create(:customer) }
  let(:repeat_customer) { create(:customer) }
  let(:another_regular_customer) { create(:customer) }

  before do
    Timecop.travel(now)

    (1..8).each do
      create( :enquiry, status: EnquiryStatus::CONFIRMED, customer: weekly_customer)
    end

    (1..5).each do
      create( :enquiry, status: EnquiryStatus::CONFIRMED, customer: regular_customer)
      create( :enquiry, status: EnquiryStatus::CONFIRMED, customer: another_regular_customer)
    end

    (1..2).each do
      create( :enquiry, status: EnquiryStatus::CONFIRMED, customer: repeat_customer)
    end

    create( :enquiry, status: EnquiryStatus::CONFIRMED)
    create( :enquiry, status: EnquiryStatus::CONFIRMED)
    create( :enquiry, status: EnquiryStatus::CONFIRMED)
    create( :enquiry, customer: regular_customer, status: EnquiryStatus::NEW)

    Timecop.return
  end

  let(:report) { CustomerReport.new(Enquiry.connection) }

  pending 'gets the number of weekly customers'
  pending 'gets the number of regular customers'
  pending 'gets the number of repeat customers'
  pending 'gets the number of new customers' 
end
