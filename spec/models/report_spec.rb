require 'rails_helper'

describe Report do
  before do
    Timecop.travel(now)
    create(
      :enquiry,
      status: EnquiryStatus::CONFIRMED,
      total_amount_paid: 100,
      payment_fee_paid: 10,
      delivery_cost: 20,
      total_cost_to_us: 50,
      event: event_details

    )
    create(
      :enquiry,
      status: EnquiryStatus::CONFIRMED,
      total_amount_paid: 120,
      payment_fee_paid: 10,
      delivery_cost: 20,
      total_cost_to_us: 60,
      event: event_details
    )
    create(:enquiry)
    Timecop.return
  end

  let(:report) { Report.new(Enquiry.connection, now - 1.hours, now + 1.hours) }
  let(:now) { Time.parse('1 Nov 2014 12:00') }
  let(:event_details) do
    EventDetails.load(
      format: '',
      type: '',
      event_date: now.strftime('%d %B %Y'),
      event_time: '',
      attendees: 20
    )
  end

  describe 'calculations from confirmed enquiries' do
    it 'counts the number of enquiries confirmed' do
      expect(report.confirmed_enquiry_count).to eq 2
    end

    it 'calculates the average enquiry value of those confirmed' do
      expect(report.average_enquiry_value).to eq 110
    end

    it 'calculates the revenue from the enquiries confirmed' do
      expect(report.total_revenue).to eq 220
    end

    it 'calculates the profit from the enquiries confirmed' do
      expect(report.gross_profit).to eq 90
    end

    pending 'calculates the number of enquiries from new customers' do
      expect(report.new_customer_count).to eq 2
    end
  end

  describe 'calculations from event date' do
    it 'calculates the number of people served from the event date' do
      expect(report.meals_served).to eq 40
    end

    it 'calculates the number of orders fulfilled from the event date' do
      expect(report.orders_fulfilled).to eq 2
    end
  end

  describe 'calculations from new enquiries' do
    it 'calculates the number of new enquiries' do
      expect(report.new_enquiries_count).to eq 3
    end
  end
end
