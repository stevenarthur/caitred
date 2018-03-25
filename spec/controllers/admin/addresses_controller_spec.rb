require 'rails_helper'

module Admin
  describe AddressesController do
    let(:customer) { create(:customer) }

    describe '#new' do
      let(:make_request) { get :new, customer_id: customer.id }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'renders the new template' do
          expect(response).to have_rendered('new')
        end
      end
    end

    describe '#create' do
      let(:make_request) do
        get :create,
            customer_id: customer.id,
            address: { line_1: 'high street', postcode: '2000', suburb: "Zetland", company: "Digital Dawn", parking_information: "All good" }
      end

      context 'authenticated' do
        let(:address) { Address.all.first }
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'creates the address' do
          expect(address.line_1).to eq 'high street'
        end

        it 'redirects to the edit page' do
          expect(response.status).to eq 302
        end
      end

      context 'json' do
        render_views
        let(:address) { Address.all.first }
        let(:make_request) do
          get :create,
              format: :json,
              customer_id: customer.id,
              address: { line_1: 'high street', postcode: '2000', suburb: "Zetland", company: "Digital Dawn", parking_information: "All good" }
        end
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          request.env['HTTP_ACCEPT'] = 'application/json'
          make_request
        end

        it 'renders the id' do

        end
      end
    end

    describe '#show' do
      let(:address) { create(:address, customer: customer) }
      let(:customer) { create(:customer) }
      let(:make_request) { get :show, customer_id: customer.id, id: address.id }

      it_behaves_like 'redirects when not authenticated'
      

      context 'authenticated' do
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'retrieves the address' do
          expect(assigns[:address]).to eq address
        end
      end
    end

    describe '#edit' do
      let(:address) { create(:address, customer: customer) }
      let(:customer) { create(:customer) }
      let(:make_request) { get :edit, customer_id: customer.id, id: address.id }

      it_behaves_like 'redirects when not authenticated'
      

      context 'authenticated' do
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'retrieves the address' do
          expect(assigns[:address]).to eq address
        end
      end
    end

    describe '#update' do
      let(:address) { create(:address, customer: customer) }
      let(:customer) { create(:customer) }

      it_behaves_like 'redirects when not authenticated'

      let(:make_request) do
        post :update,
             customer_id: customer.id,
             id: address.id,
             address: {
               line_1: 'main street',
               line_2: 'somewhere',
               suburb: 'sydney',
               postcode: '2000',
               parking_information: 'out front'
             }
      end

      context 'authenticated' do
        before do
          allow_any_instance_of(AddressesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
          address.reload
        end

        it 'returns a no content response' do
          expect(response.status).to eq 204
        end

        it 'sets the address line 1' do
          expect(address.line_1).to eq 'main street'
        end

        it 'sets the address line 2' do
          expect(address.line_2).to eq 'somewhere'
        end

        it 'sets the address suburb' do
          expect(address.suburb).to eq 'sydney'
        end

        it 'sets the address postcode' do
          expect(address.postcode).to eq '2000'
        end

        it 'sets the parking information' do
          expect(address.parking_information).to eq 'out front'
        end
      end
    end

    describe '#set_default' do
      let(:default_address) { create(:address, default: true) }
      let(:other_address_1) { create(:address) }
      let(:other_address_2) { create(:address) }
      let(:customer) { create(:customer) }
      let(:make_request) do
        post :set_default,
             customer_id: customer.id,
             address_id: other_address_1.id
      end
      before do
        customer.addresses = addresses
        allow_any_instance_of(AddressesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
        [other_address_1, other_address_2, default_address].each(&:reload)
      end

      context 'no other default addresses' do
        let(:addresses) { [other_address_1, other_address_2] }

        it 'sets the address to default' do
          expect(other_address_1.default?).to be true
        end

        it 'returns a no content response' do
          expect(response.status).to eq 204
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

        it 'returns a no content response' do
          expect(response.status).to eq 204
        end
      end
    end

  end
end
