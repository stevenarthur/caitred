require 'rails_helper'

describe Customer do

  describe '#find_by_email' do
    let(:email) { 'somebody@hotmail.com' }
    let!(:customer) { create(:customer, email: email) }

    context 'invalid email' do

      it 'returns nil for nil' do
        expect(Customer.find_by_email(nil)).to be_nil
      end

      it 'returns nil for empty' do
        expect(Customer.find_by_email('')).to be_nil
      end

      it 'returns nil for unmatched' do
        result = Customer.find_by_email('nobody@hotmail.com')
        expect(result).to be_nil
      end

    end

    context 'valid email' do

      it 'returns the customer record' do
        result = Customer.find_by_email(email)
        expect(result).to eq customer
      end
    end

  end

  describe '#name' do
    let!(:customer) { Customer.new first_name: 'Katy', last_name: 'Perry' }

    it 'joins the first and last name' do
      expect(customer.name).to eq 'Katy Perry'
    end
  end

  describe '#description' do
    let!(:customer) do
      create(:customer,
             first_name: 'Katy',
             last_name: 'Perry',
             company_name: company,
             email: email
      )
    end

    context 'all valid details' do
      let(:email) { 'kp@hotmail.com' }
      let(:company) { 'Sony' }

      it 'formats the description' do
        expect(customer.description).to eq 'Katy Perry (kp@hotmail.com)'
      end
    end

    context 'no company' do
      let(:email) { 'kp@hotmail.com' }
      let(:company) { 'must have a company' }

      it 'puts no email in place of the blank email' do
        expect(customer.description).to eq 'Katy Perry (kp@hotmail.com)'
      end
    end

  end

  describe '#as_json' do
    let(:customer) { Customer.new }

    it 'adds the description' do
      expect(customer.as_json).to have_key :description
    end

  end

  describe '#by_name' do
    let!(:customer_1) { create(:customer, first_name: 'Bob', last_name: 'Marley') }
    let!(:customer_2) { create(:customer, first_name: 'Paul', last_name: 'McCartney') }
    let(:results) { Customer.by_name('Bob', 'Marley') }

    it 'gets the right number of matching customers' do
      expect(results.size).to be 1
    end

    it 'gets the matching customer' do
      expect(results).to include customer_1
    end

    it 'does not include the non-matching customer' do
      expect(results).not_to include customer_2
    end
  end

  describe '#default_address' do
    let(:customer) { create(:customer) }

    context 'when the customer has no address' do
      it 'returns nil' do
        expect(customer.default_address).to be_nil
      end
    end

    context 'when the customer has one address' do
      let(:address) { create(:address) }
      before do
        customer.addresses = [address]
        customer.save!
      end

      it 'returns the address' do
        expect(customer.default_address).to eq address
      end
    end

    context 'multiple addresses no default' do
      let(:address_1) { create(:address) }
      let(:address_2) { create(:address) }
      before do
        customer.addresses = [address_1, address_2]
        customer.save!
      end

      it 'returns the first address' do
        expect(customer.default_address).to eq address_1
      end
    end

    context 'with multiple addresses and one set to default' do
      let(:address_1) { create(:address) }
      let(:address_2) { create(:address, default: true) }
      before do
        customer.addresses = [address_1, address_2]
        customer.save!
      end

      it 'returns the default address' do
        expect(customer.default_address).to eq address_2
      end
    end
  end

  describe '#has_addresses' do
    let(:customer) { create(:customer) }

    context 'when the customer has one address' do
      let(:address) { create(:address) }
      before do
        customer.addresses = [address]
        customer.save!
      end

      it 'returns one' do
        expect(customer.addresses?).to eq :one
      end
    end

    context 'when the customer has no addresses' do
      it 'returns none' do
        expect(customer.addresses?).to eq :none
      end
    end

    context 'when the customer has multiple addresses' do
      let(:address_1) { create(:address) }
      let(:address_2) { create(:address, default: true) }
      before do
        customer.addresses = [address_1, address_2]
        customer.save!
      end

      it 'returns many' do
        expect(customer.addresses?).to eq :many
      end
    end
  end

  describe '#default_address=' do
    let(:default_address) { create(:address, default: true) }
    let(:other_address_1) { create(:address) }
    let(:other_address_2) { create(:address) }
    let(:customer) { create(:customer) }

    before do
      customer.addresses = addresses
      customer.default_address = other_address_1
      [other_address_1, other_address_2, default_address].each(&:reload)
    end

    context 'no other default addresses' do
      let(:addresses) { [other_address_1, other_address_2] }

      it 'sets the address to default' do
        expect(other_address_1.default?).to be true
      end
    end

    context 'customer has other default address' do
      let(:addresses) { [default_address, other_address_1, other_address_2] }

      it 'sets the address to default' do
        expect(other_address_1.default?).to be true
      end

      it 'removes the default from the other address' do
        expect(default_address.default?).to be false
      end
    end

  end

end
