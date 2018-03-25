require 'rails_helper'

module Admin
  describe CustomersController, type: :controller do

    describe '#index' do
      let(:make_request) { get :index }

      
      it_behaves_like 'requires admin authentication'

      context 'with customers' do
        let!(:customer_1) { create(:customer) }
        let!(:customer_2) { create(:customer) }

        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          get :index
        end

        it 'has the right number of customers' do
          expect(assigns(:customers).size).to be 2
        end

        it 'retrieves the customers' do
          expect(assigns(:customers)).to include customer_1
          expect(assigns(:customers)).to include customer_2
        end

      end

    end

    describe '#edit' do
      let(:customer) { create(:customer) }
      let(:make_request) { get :edit, id: customer.id }

      
      it_behaves_like 'requires admin authentication'

      describe 'retrieving the customer' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          get :index
        end

        it 'gets the customer' do
          make_request
          expect(assigns(:customer)).to eq customer
        end
      end
    end

    describe '#new' do
      let(:make_request) { get :new }

      
      it_behaves_like 'requires admin authentication'

    end

    describe '#enquiries' do
      let!(:customer) { create(:customer) }
      let!(:enquiry_1) { create(:enquiry, customer: customer) }
      let!(:enquiry_2) { create(:enquiry, customer: customer) }
      let!(:enquiry_3) { create(:enquiry) }
      let(:make_request) { get :enquiries, customer_id: customer.id }

      
      it_behaves_like 'requires admin authentication'

      describe 'retrieving data' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'retrieves the customer' do
          expect(assigns(:customer)).to eq customer
        end
        it 'retrieves the correct number of enquiries' do
          expect(assigns(:enquiries).size).to eq 2
        end
        it 'retrieves the correct enquiries' do
          expect(assigns(:enquiries)).to include enquiry_1
          expect(assigns(:enquiries)).to include enquiry_2
        end

        it 'does not retrieve the enquiries belonging to other customers' do
          expect(assigns(:enquiries)).not_to include enquiry_3
        end

      end
    end

    describe '#create' do
      let(:make_request) { post :create, params }
      let(:params) do
        {
          customer: {
            email: 'test@blah.com',
            first_name: 'Mariah',
            last_name: 'Carey',
            telephone: "0425616308",
            company_name: 'Eurostar',
            preferences: {
              opt_out: 1,
              communication_method: 'email'
            }

          }
        }
      end

      it_behaves_like 'redirects when not authenticated'

      context 'successful creation of a customer' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end
        let(:customer) { Customer.all.first }

        it 'creates a new customer' do
          expect(Customer.all.size).to eq 1
        end

        it 'sets the customer\'s email' do
          expect(customer.email).to eq 'test@blah.com'
        end

        it 'sets the customer\'s first name' do
          expect(customer.first_name).to eq 'Mariah'
        end

        it 'sets the customer\'s last name' do
          expect(customer.last_name).to eq 'Carey'
        end

        it 'sets the customer\'s company name' do
          expect(customer.company_name).to eq 'Eurostar'
        end

        it 'sets the opt-out' do
          expect(customer.preferences.opt_out).to eq true
        end

        it 'sets the communication preference' do
          expect(customer.preferences.communication_method).to eq 'email'
        end

        it 'sets the success message' do
          expect(flash[:success]).to eq 'Customer created'
        end

        it 'redirects to the edit path' do
          expect(response).to redirect_to edit_admin_customer_path(customer)
        end

      end

      context 'invalid email' do
        let(:params) do
          {
            customer: {
              email: 'blah',
              first_name: 'hello',
              telephone: '0425616381',
              last_name: 'world',
              company_name: ''
            }
          }
        end
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'does not create a new customer' do
          expect(Customer.all.size).to be 0
        end

        it 'sets the error message' do
          expect(flash[:error])
            .to eq 'Email is invalid.'
        end

        it_behaves_like 'bad request'

      end
    end

    describe '#update' do
      let(:make_request) { post :update, params }
      let!(:customer) { create(:customer) }
      let(:params) do
        {
          id: customer.id,
          customer: {
            email: 'test@blah.com',
            first_name: 'Mariah',
            last_name: 'Carey',
            company_name: 'Eurostar',
            preferences: {
              opt_out: 1,
              communication_method: 'email'
            }

          }
        }
      end

      it_behaves_like 'redirects when not authenticated'

      context 'successful update of a customer' do
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        it 'sets the customer\'s email' do
          expect(customer.email).to eq 'test@blah.com'
        end

        it 'sets the customer\'s first name' do
          expect(customer.first_name).to eq 'Mariah'
        end

        it 'sets the customer\'s last name' do
          expect(customer.last_name).to eq 'Carey'
        end

        it 'sets the customer\'s company name' do
          expect(customer.company_name).to eq 'Eurostar'
        end

        it 'sets the opt-out' do
          expect(customer.preferences.opt_out).to eq true
        end

        it 'sets the communication preference' do
          expect(customer.preferences.communication_method).to eq 'email'
        end

        it 'sets the success message' do
          expect(flash[:success]).to eq 'Customer updated'
        end

        it 'redirects to the edit path' do
          expect(response).to redirect_to edit_admin_customer_path(customer)
        end

      end

      context 'invalid email' do
        let(:params) do
          {
            id: customer.id,
            customer: {
              email: 'blah',
              first_name: 'first',
              last_name: 'last',
              company_name: ''
            }
          }
        end
        before do
          allow_any_instance_of(described_class)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        it 'sets the error message' do
          expect(flash[:error])
            .to eq 'Email is invalid.'
        end

        it_behaves_like 'bad request'

      end
    end
  end
end
