require 'rails_helper'

shared_examples 'updates enquiry properties' do

  describe 'order properties' do

    it 'updates additional messages' do
      expect(enquiry.additional_messages).to eq 'more to say'
    end

  end

  describe 'customer updates' do

    it 'updates the customer id' do
      expect(enquiry.customer.id).to eq customer.id
    end

  end

  describe 'event updates' do

    it 'updates the date' do
      expect(enquiry.event_date.strftime('%d %B %Y')).to eq '12 July 2014'
    end

    it 'updates the time' do
      expect(enquiry.event_time.strftime("%l:%M %p")).to eq ' 9:30 PM'
    end

    pending 'updates total_cost_to_us' do
      expect(enquiry.total_cost_to_us).to eq 90
    end

  end

  describe 'address updates' do
    it 'updates the parking information' do
      expect(enquiry.address.parking_information).to eq 'Round the back'
    end
  end

end

module Admin
  describe EnquiriesController, type: :controller do
    let(:directory) { 'tmp/emails' }
    let(:customer) { create(:customer) }
    let(:params) do
      {
        id: enquiry.id
      }.merge(posted_data)
    end
    let(:posted_data) do
      {
        enquiry: {
          customer_id: customer.id,
          address: {
            line_1: "Testing",
            suburb: "Test Suburb",
            postcode: "2000",
            company: "Facebook",
            parking_information: "Round the back"
          },
          event_date: '12 Jul 2014',
          event_time: '9:30pm',
          additional_messages: 'more to say',
          delivery_cost: 0,
          delivery_cost_to_us: 0,
          total_cost_to_us: 0
        }
      }
    end

    after do
      FileUtils.rm_rf(directory)
    end

    describe '#new_for_customer' do
      let(:customer) { create(:customer) }
      let(:enquiry) { customer.enquiries.first }
      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        post :new_for_customer, id: customer.id
      end

      it 'creates a new enquiry for the customer' do
        expect(customer.enquiries.size).to be 1
      end

      it 'redirects to the admin path' do
        expect(response.code).to eq '302'
        expect(response).to redirect_to edit_admin_enquiry_path(enquiry)
      end

    end

    describe '#update' do
      let!(:enquiry) { create(:enquiry, customer: customer) }

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        patch :update, params
        enquiry.reload
      end

      it_behaves_like 'updates enquiry properties'

      pending 'recalculates the total cost'
    end

    describe '#new' do
      let(:make_request) { get :new }
      it_behaves_like 'redirects when not authenticated'
      

      context 'rendering the page' do
        before do
          allow_any_instance_of(EnquiriesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'renders the new template' do
          expect(response).to have_rendered(:new)
        end
      end
    end

    describe '#index' do
      let!(:enquiry_1) { create(:enquiry, status: EnquiryStatus::NEW) }
      let!(:enquiry_2) { create(:enquiry, status: EnquiryStatus::DELIVERED) }
      let(:make_request) { get :index }
      it_behaves_like 'redirects when not authenticated'
      

      context 'displaying enquiries' do
        before do
          allow_any_instance_of(EnquiriesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'displays all of the processing enquiries' do
          expect(assigns[:processing_enquiries].size).to be 1
        end

        it 'displays all of the processing enquiries' do
          expect(assigns[:confirmed_enquiries].size).to be 1
        end

        it 'includes the processing enquiries' do
          expect(assigns[:processing_enquiries]).to include enquiry_1

        end

        it 'includes the confirmed enquiries' do
          expect(assigns[:confirmed_enquiries]).to include enquiry_2
        end
      end
    end

    describe '#create' do
      let(:make_request) { get :create, posted_data }
      let(:enquiry) { Enquiry.all.first }

      it_behaves_like 'redirects when not authenticated'

      context 'creates the enquiry' do
        before do
          allow_any_instance_of(EnquiriesController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'creates an enquiry' do
          expect(Enquiry.all.size).to be 1
        end

        it_behaves_like 'updates enquiry properties'
      end
    end

    describe '#edit' do
      let!(:enquiry) { create(:enquiry) }
      let(:make_request) { get :edit, id: enquiry.id }

      it_behaves_like 'redirects when not authenticated'
      

    end

    describe '#progress' do
      render_views

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        request.env['HTTP_ACCEPT'] = 'application/json'
        post :progress, id: enquiry.id, format: 'json'
      end

      context 'new' do
        let(:enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }

        it 'moves forward in the workflow' do
          enquiry.reload
          expect(enquiry.status).to eq EnquiryStatus::PROCESSING
        end

        it 'returns json content with the new status' do
          json = JSON.parse(response.body)
          expect(json['new_status']).to eq EnquiryStatus::PROCESSING
        end

        it 'includes the new next status in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['next_status']).to eq EnquiryStatus::WAITING_ON_SUPPLIER
        end

        it 'includes can progress in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_progress']).to eq 'true'
        end

        it 'includes can cancel in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_cancel']).to eq 'true'
        end

        it 'includes can mark as test or spam JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_mark_test_or_spam']).to eq 'true'
        end
      end
    end

    describe '#regress' do
      render_views

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        request.env['HTTP_ACCEPT'] = 'application/json'
        post :regress, enquiry_id: enquiry.id, format: 'json'
      end

      context 'new' do
        let(:enquiry) { create(:enquiry, status: EnquiryStatus::WAITING_ON_SUPPLIER) }

        it 'moves backward in the workflow' do
          enquiry.reload
          expect(enquiry.status).to eq EnquiryStatus::PROCESSING
        end

        it 'returns json content with the new status' do
          json = JSON.parse(response.body)
          expect(json['new_status']).to eq EnquiryStatus::PROCESSING
        end

        it 'includes the new previous status in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['last_status']).to eq EnquiryStatus::NEW
        end

        it 'includes can regress in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_regress']).to eq 'true'
        end

        it 'includes can cancel in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_cancel']).to eq 'true'
        end

        it 'includes can mark as test or spam JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_mark_test_or_spam']).to eq 'true'
        end
      end
    end

    describe '#spam' do
      render_views

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        request.env['HTTP_ACCEPT'] = 'application/json'
        post :spam, id: enquiry.id, format: 'json'
      end

      context 'new' do
        let(:enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }

        it 'changes it to have a status of spam' do
          enquiry.reload
          expect(enquiry.status).to eq EnquiryStatus::SPAM
        end

        it 'returns json content with the new status' do
          json = JSON.parse(response.body)
          expect(json['new_status']).to eq EnquiryStatus::SPAM
        end

        it 'does not include the next status in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['next_status']).to be_nil
        end

        it 'includes can progress in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_progress']).to eq 'false'
        end

        it 'includes can cancel in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_cancel']).to eq 'false'
        end

        it 'includes can mark as test or spam JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_mark_test_or_spam']).to eq 'false'
        end
      end
    end

    describe '#test' do
      render_views

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        request.env['HTTP_ACCEPT'] = 'application/json'
        post :test, id: enquiry.id, format: 'json'
      end

      context 'new' do
        let(:enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }

        it 'changes it to have a status of test' do
          enquiry.reload
          expect(enquiry.status).to eq EnquiryStatus::TEST
        end

        it 'returns json content with the new status' do
          json = JSON.parse(response.body)
          expect(json['new_status']).to eq EnquiryStatus::TEST
        end

        it 'does not include the next status in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['next_status']).to be_nil
        end

        it 'includes can progress in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_progress']).to eq 'false'
        end

        it 'includes can cancel in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_cancel']).to eq 'false'
        end

        it 'includes can mark as test or spam JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_mark_test_or_spam']).to eq 'false'
        end
      end
    end

    describe '#cancel' do
      render_views

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        request.env['HTTP_ACCEPT'] = 'application/json'
        post :cancel, id: enquiry.id, format: 'json'
      end

      context 'new' do
        let(:enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }

        pending 'changes it to have a status of cancelled' do
          enquiry.reload
          expect(enquiry.status).to eq EnquiryStatus::CANCELLED
        end

        pending 'returns json content with the new status' do
          json = JSON.parse(response.body)
          expect(json['new_status']).to eq EnquiryStatus::CANCELLED
        end

        pending 'does not include the next status in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['next_status']).to be_nil
        end

        pending 'includes can progress in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_progress']).to eq 'false'
        end

        pending 'includes can cancel in the JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_cancel']).to eq 'false'
        end

        pending 'includes can mark as test or spam JSON response' do
          json = JSON.parse(response.body)
          expect(json['can_mark_test_or_spam']).to eq 'false'
        end
      end
    end

    describe '#set_address' do
      let(:enquiry) { create(:enquiry, customer: customer) }
      let(:address) { create(:address) }
      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        post :set_address, enquiry_id: enquiry.id, address_id: address.id
      end

      it 'sets the address' do
        enquiry.reload
        expect(enquiry.address).to eq address
      end

      it 'redirects to show address page' do
        expect(response.status).to eq 204
      end
    end

    describe '#enquiry_address' do
      let(:enquiry) { create(:enquiry, customer: customer) }
      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        post :enquiry_address, enquiry_id: enquiry.id
      end

      it_behaves_like 'OK response'

      it 'gets the enquiry' do
        expect(assigns[:enquiry]).to eq enquiry
      end
    end

    describe '#send_confirmation_link' do
      let(:enquiry) do
        create(
          :enquiry,
          customer: customer,
          status: status,
          confirmation_token: '1234'
        )
      end
      let(:message) { File.read("#{directory}/email2.txt") }
      let(:message_json) { JSON.parse(message) }

      before do
        allow_any_instance_of(EnquiriesController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        post :send_confirmation_link, enquiry_id: enquiry.id
      end

      context 'status is ready to confirm' do
        let(:status) { EnquiryStatus::READY_TO_CONFIRM }

        it 'returns a no content header' do
          expect(response.status).to eq 204
        end

        pending 'sends an email' do
          expect(message_json['subject']).to eq 'Please confirm your You Chews Order'
        end
      end

      context 'status is not ready to confirm' do
        let(:status) { EnquiryStatus::NEW }

        it_behaves_like 'bad request'

        it 'does not send an email' do
          expect(File.exist?("#{directory}/email2.txt")).to eq false
        end
      end
    end
  end
end
