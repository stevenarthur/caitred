require 'rails_helper'

describe EnquiryHelper do
  describe '#time_options' do
    it 'creates a list of options for every 15 minutes' do
      expect(EnquiryHelper.time_options.size).to eq 96
    end
  end

  describe '#address_partial' do
    before do
      assign(:enquiry, enquiry)
    end

    context 'address not set' do
      let(:enquiry) do
        enquiry = create(:enquiry, customer: customer)
        enquiry.address_id = nil
        enquiry
      end

      context 'customer has no addresses' do
        let(:customer) { create(:customer) }

        it 'returns the no_addresses template' do
          expect(helper.address_partial).to eq 'no_addresses'
        end
      end

      context 'customer has addresses' do
        let(:customer) do
          customer = create(:customer)
          customer.addresses = [create(:address)]
          customer
        end

        it 'returns the no_address_set template' do
          expect(helper.address_partial).to eq 'no_address_set'
        end
      end
    end

    context 'address is set' do
      let(:enquiry) { create(:enquiry, customer: customer) }

      context 'customer has one addresses' do
        let(:customer) do
          customer = create(:customer)
          customer.addresses = [create(:address)]
          customer
        end

        it 'returns the one_address template' do
          expect(helper.address_partial).to eq 'one_address'
        end
      end

      context 'customer has multiple addresses' do
        let(:customer) do
          customer = create(:customer)
          customer.addresses = [create(:address), create(:address)]
          customer
        end

        it 'returns the mutiple_addresses template' do
          expect(helper.address_partial).to eq 'multiple_addresses'
        end
      end
    end
  end

  describe '#enquiry_form_url' do

    context 'enquiry is an enquiry' do
      let(:enquiry) { create(:enquiry) }
      before do
        assign(:enquiry, enquiry)
      end

      it 'is the update path' do
        expect(helper.enquiry_form_url).to eq admin_enquiry_path(enquiry)
      end
    end

    context 'enquiry is not saved' do
      before do
        assign(:enquiry, Enquiry.new)
      end

      it 'is the create path' do
        expect(helper.enquiry_form_url).to eq admin_enquiries_path
      end
    end
  end

  describe 'address_options' do
    let(:address_1) { create(:address, line_1: 'addr 1') }
    let(:address_2) { create(:address, line_1: 'addr 2') }
    let(:customer) do
      customer = create(:customer)
      customer.addresses = [address_1, address_2]
      customer
    end
    let(:enquiry) { create(:enquiry, customer: customer) }
    before do
      assign(:enquiry, enquiry)
    end

    it 'returns an array of address lines and id' do
      expect(helper.address_options).to eq [
       ["Facebook, addr 1, Randwick, 2000", address_1.id], ["Facebook, addr 2, Randwick, 2000", address_2.id]
      ]
    end
  end

  describe 'food_partner_options' do
    let!(:partner_1) { create(:food_partner, company_name: 'partner 1') }
    let!(:partner_2) { create(:food_partner, company_name: 'partner 2') }

    it 'returns an array of address lines and id' do
      expect(helper.food_partner_options).to eq [
        ['partner 1', partner_1.id],
        ['partner 2', partner_2.id]
      ]
    end
  end

  describe 'payment_fee_type' do
    let(:enquiry) do
      create(
        :enquiry,
        payment_method: payment_method
      )
    end

    before do
      assign(:enquiry, enquiry)
    end

    context 'when payment fee is valid' do
      let(:payment_method) { PaymentMethod::CREDIT_CARD.to_s }

      it 'returns the payment fee type' do
        expect(helper.payment_fee_type).to eq 'Credit Card'
      end
    end

    context 'when payment fee is nil' do
      let(:payment_method) { nil }

      it 'returns the payment fee type' do
        expect(helper.payment_fee_type).to be_nil
      end
    end
  end

  describe 'status_class' do
    let(:enquiry) do
      create(
        :enquiry,
        status: 'something someTHING abc'
      )
    end

    before do
      assign(:enquiry, enquiry)
    end

    it 'creates a CSS friendly class name prefixed by status' do
      expect(helper.status_class).to eq 'status-something-something-abc'
    end
  end

  describe 'budget_options' do
    it 'returns an array of options' do
      expect(helper.budget_options).to be_a Array
    end
  end

end
