require 'rails_helper'

describe CustomerHelper do
  describe '#mailing_list?' do
    context 'customer did not opt out' do
      let(:customer) { create(:customer) }
      it 'returns yes' do
        expect(helper.mailing_list?(customer)).to eq 'yes'
      end
    end

    context 'customer opted out' do
      let(:customer) do
        create(
          :customer,
          preferences: { opt_out: '1' }
        )
      end

      it 'returns no' do
        expect(helper.mailing_list?(customer)).to eq 'no'
      end
    end
  end

  describe '#registered?' do
    context 'registered' do
      let(:customer) { create(:customer, created_account: true) }

      it 'returns yes' do
        expect(helper.registered?(customer)).to eq 'yes'
      end
    end

    context 'not registered' do
      let(:customer) { create(:customer) }

      it 'returns no' do
        expect(helper.registered?(customer)).to eq 'no'
      end
    end
  end

  describe '#customer_form_url' do
    before do
      assign(:customer, customer)
    end

    context 'customer has id' do
      let(:customer) { create(:customer) }

      it 'returns yes' do
        expect(helper.customer_form_url).to eq admin_customer_path(customer)
      end
    end

    context 'not registered' do
      let(:customer) { build(:customer) }

      it 'returns no' do
        expect(helper.customer_form_url).to eq admin_customers_path
      end
    end
  end
end
