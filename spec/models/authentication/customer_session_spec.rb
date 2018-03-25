require 'rails_helper'
require 'authlogic/test_case'

module Authentication
  describe CustomerSession do
    include Authlogic::TestCase

    setup :activate_authlogic

    describe '#persisted?' do
      let(:customer) do
        create( :customer, password: 'pass')
      end
      let(:session) do
        CustomerSession.create!( email: customer.email, password: customer.password)
      end

      it 'is always false' do
        expect(session.persisted?).to be false
      end

    end

    describe '#to_key' do
      let(:customer) do
        create( :customer, password: 'pass')
      end

      context 'model is not saved' do
        let(:session) do
          CustomerSession.new( email: customer.email, password: customer.password)
        end

        it 'returns nil' do
          expect(session.to_key).to be_nil
        end
      end
    end
  end
end
