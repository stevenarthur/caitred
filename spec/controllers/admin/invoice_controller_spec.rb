require 'rails_helper'

module Admin
  describe InvoiceController do
    let(:address) { create(:address) }
    let(:customer) do
      customer = create(:customer)
      customer.addresses = [address]
      customer
    end
    let(:enquiry) { create(:enquiry, customer: customer) }
    let(:invoice) { double(save: true) }

    before do
      allow(Xero::CustomerInvoiceCreator).to receive(:from_enquiry)
        .and_return(invoice)
    end

    describe '#create' do
      let(:make_request) { post :create, enquiry_id: enquiry.id, format: :json }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          allow_any_instance_of(InvoiceController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'creates an invoice' do
          expect(invoice).to have_received(:save)
        end
      end
    end
  end
end
