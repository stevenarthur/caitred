require 'rails_helper'

module Xero
  describe SupplierInvoiceCreator do
    let(:address) do
      create(
        :address,
        company: 'John Smith Inc',
        line_1: 'somewhere',
        line_2: 'over the rainbow',
        postcode: '2000',
        suburb: 'Sydney'
      )
    end

    let(:customer) do
      customer = Customer.create!(first_name: 'Paul', last_name: 'Millar', telephone: '0425616397',
                                  email: 'paul@paulmillar.net', created_account: true)  
      customer.addresses = [address]
      customer
    end
    let(:invoice_builder) { double(build: invoice) }
    let(:contact_builder) { double(build: contact) }
    let(:invoice) do
      double(
        :contact= => contact,
        :branding_theme_id= => nil,
        :line_amount_types= => nil,
        :due_date= => nil,
        :reference= => nil,
        :status= => nil,
        :add_line_item => nil,
        :save => nil
      )
    end
    let(:contact) { double(add_address: nil) }
    let(:xero_client) do
      double(
        Invoice: invoice_builder,
        Contact: contact_builder
      )
    end
    let(:food_partner){ create(:food_partner, company_name: "Pips Fish n Chips") }
    let(:packageable_item_1){ create(:packageable_item, food_partner_id: food_partner.id,
                                     title: "Cheese & Jam Sandwich", cost: 15.00) }
    let(:packageable_item_2){ create(:packageable_item, food_partner_id: food_partner.id,
                                     title: "Ham Sandwich", cost: 18.00) }
    let(:enquiry) do
      create(
        :enquiry,
        id: 15,
        food_partner_id: food_partner.id,
        customer: customer,
        address: address,
        menu_title: 'happy chicken',
        event_time: '3pm',
        price_per_head: 15,
        event_date: '18 Dec 2014',
        delivery_cost: 10,
        payment_method: payment_method
      )
    end

    let(:current_time) { Time.parse('25 November 2014') }
    let(:payment_method) { PaymentMethod::CREDIT_CARD.to_s }
    let(:enquiry_item_1){ EnquiryItem.create!(packageable_item_id: packageable_item_1.id,
                          unit_price: packageable_item_1.cost, enquiry_id: enquiry.id,
                          quantity: 1, total_price: (packageable_item_1.cost * 1)) }
    let(:enquiry_item_2){ EnquiryItem.create!(packageable_item_id: packageable_item_2.id,
                          unit_price: packageable_item_2.cost, enquiry_id: enquiry.id,
                          quantity: 2, total_price: (packageable_item_2.cost * 2)) }


    before do
      enquiry_item_1
      enquiry_item_2
      enquiry.reload

      allow(XeroClient).to receive(:client).and_return(xero_client)
      Timecop.freeze(current_time)
      subject
    end

    after do
      Timecop.return
    end

    it 'returns an Invoice' do
      expect(subject).to eq(invoice)
    end

  end
end
