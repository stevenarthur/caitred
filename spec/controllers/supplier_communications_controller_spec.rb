require 'rails_helper'

module Admin
  describe SupplierCommunicationsController do

    let(:supplier) { create(:food_partner) }
    event_params = {:event_date => "03/04/2015"}
    let(:enquiry) { create(:enquiry, food_partner: supplier, event_date: "12/12/2017") }
    let(:email_content) { 'Hello, we have an order for you' }

    let(:message) { Mailers::PartnerNewOrderMail.new(enquiry, email_content).message }
    

    describe '#create' do
      let(:make_request) do
        post :create,
             enquiry_id: enquiry.id,
             email_content: "This is the overridden menu",
             format: :json
      end

      #
      #it_behaves_like 'requires admin authentication'

      context 'with ssl and authentication' do
        before do
          allow_any_instance_of(Admin::SupplierCommunicationsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
        end

        it 'creates a new supplier communications object' do
          expect(enquiry.persisted?).to eq true
          make_request
          expect(enquiry.supplier_communications.length).to eq 1
        end

        it 'sends an email to the supplier' do
          make_request
          expect(enqueued_jobs.size).to eq(1) 
          expect(enqueued_jobs[0][:args][0]).to eq "FoodPartnerMailer"
          expect(enqueued_jobs[0][:args][1]).to eq "new_order_notice"
        end
      end
    end

  end
end
