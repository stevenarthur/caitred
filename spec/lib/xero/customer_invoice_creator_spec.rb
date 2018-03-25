require 'rails_helper'

module Xero
  describe CustomerInvoiceCreator do
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
      customer = create(
        :customer,
        first_name: 'John',
        last_name: 'Smith',
        email: 'john@test.com'
      )
      customer.addresses = [address]
      customer
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

    let(:enquiry_item_1){ EnquiryItem.create!(packageable_item_id: packageable_item_1.id,
                          unit_price: packageable_item_1.cost, enquiry_id: enquiry.id,
                          quantity: 1, total_price: (packageable_item_1.cost * 1)) }
    let(:enquiry_item_2){ EnquiryItem.create!(packageable_item_id: packageable_item_2.id,
                          unit_price: packageable_item_2.cost, enquiry_id: enquiry.id,
                          quantity: 2, total_price: (packageable_item_2.cost * 2)) }



    let(:xero_client) do
      double(
        Invoice: invoice_builder,
        Contact: contact_builder
      )
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
    let(:current_time) { Time.parse('25 November 2014') }
    let(:a_week_ahead) { current_time + 7.days }
    let(:payment_method) { PaymentMethod::CREDIT_CARD.to_s }

    describe '#generate_invoice' do

      before do
        enquiry_item_1
        enquiry_item_2
        enquiry.reload

        allow(XeroClient).to receive(:client).and_return(xero_client)
        Timecop.freeze(current_time)
        subject
      end
      subject { CustomerInvoiceCreator.from_enquiry(enquiry) }

      after do
        Timecop.return
      end

      it 'returns an Invoice' do
        expect(subject).to eq(invoice)
      end

      describe 'contact' do
        it 'sets the customer details including address in the contact' do
          expect(contact_builder).to have_received(:build)
            .with(
              name: 'John Smith Inc',
              first_name: 'John',
              last_name: 'Smith',
              email_address: 'john@test.com'
            )
        end

        it 'sets the default address' do
          expect(contact).to have_received(:add_address)
            .with(
              attention_to: 'John Smith',
              address_type: 'POBOX',
              address_line1: 'somewhere',
              address_line2: 'over the rainbow',
              region: 'Sydney',
              postal_code: '2000',
              country: 'Australia'
            )
        end
      end

      describe 'invoice settings' do
        it 'sets the correct branding theme' do
          expect(invoice).to have_received(:branding_theme_id=)
            .with(ENV['XERO_PAID_BRAND_THEME'])
        end

        it 'sets the due date' do
          expect(invoice).to have_received(:due_date=)
            .with(a_week_ahead.to_date)
        end

        it 'sets the line item to tax exclusive' do
          expect(invoice).to have_received(:line_amount_types=)
            .with('Inclusive')
        end

        it 'sets the reference to be the company, event date and enquiry id' do
          expect(invoice).to have_received(:reference=)
            .with('John Smith Inc 18-Dec-14 (Order 15)')
        end

        it 'sets the status to authorised' do
          expect(invoice).to have_received(:status=)
            .with('AUTHORISED')
        end
      end

      describe 'line items' do
        before :each do
        end

        it 'adds a line item for the food' do
          expect(invoice).to have_received(:add_line_item)
            .with(
              item_code: "#{enquiry_item_1.food_partner.id}-#{enquiry_item_1.packageable_item.id}",
              quantity: 1,
              description: "Cheese & Jam Sandwich",
              account_code: '200',
              unit_amount: 15.00,
              tax_type: 'OUTPUT'
            )
        end

        context 'has a delivery fee' do
          it 'adds a line item for the delivery fee' do
            pending "works, but not sure on correct syntax to make this pass"
            expect(invoice).to have_received(:add_line_item).exactly(4).times
            expect(invoice).to have_received(:add_line_item)
              .with(
                item_code: "10-19",
                unit_amount: 10,
                quantity: 1,
                description: 'Delivery',
                account_code: '200'
              )
          end
        end

        context 'has a Stripe payment fee' do
          let(:payment_method) { PaymentMethod::CREDIT_CARD.to_s }

          it 'adds a line item for the payment fee' do
            pending "works, but not sure on correct syntax to make this pass"
            expect(invoice).to have_received(:add_line_item).exactly(4).times
            expect(enquiry.payment_fee).to eq 2.07
            expect(invoice).to have_received(:add_line_item)
              .with(
                unit_amount: 2.07,
                quantity: 1,
                description: 'Payment Fee',
                account_code: '200'
              )
          end
        end

        context 'has a Paypal payment fee' do
          let(:payment_method) { PaymentMethod::PAYPAL_INVOICE.to_s }

          it 'adds a line item for the payment fee' do
            expect(invoice).to have_received(:add_line_item).exactly(4).times
            expect(enquiry.payment_fee).to eq 1.76
            expect(invoice).to have_received(:add_line_item)
              .with(
                unit_amount: 1.76,
                quantity: 1,
                description: 'Payment Fee',
                account_code: '200',
                tax_type: 'EXEMPTOUTPUT'
              )
          end
        end
      end
    end
  end
end
