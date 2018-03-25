#require 'rails_helper'
#
#module Web
#  describe EnquiryConfirmationController do
#    let(:directory) { 'tmp/emails' }
#    let(:token) { SecureRandom.urlsafe_base64(30) }
#    after do
#      FileUtils.rm_rf(directory)
#    end
#
#    describe '#new' do
#      let(:make_request) { get :new, token: token }
#      let(:customer) { create(:customer) }
#      let(:address) { create(:address) }
#      render_views
#
#      
#
#      context 'valid token' do
#        let!(:enquiry) do
#          create(
#            :enquiry,
#            price_per_head: 10,
#            customer: customer,
#            address: address,
#            confirmation_token: token,
#            confirmation_token_created: Time.now
#          )
#        end
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'displays the page' do
#          expect(response).to have_rendered 'new'
#        end
#      end
#
#      context 'expired token' do
#        let!(:enquiry) do
#          create(
#            :enquiry,
#            confirmation_token: token,
#            confirmation_token_created: 12.days.ago
#          )
#        end
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'renders the please request a new token' do
#          expect(response).to have_rendered 'token_expired'
#        end
#      end
#
#      context 'no token' do
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'renders the error no token found page' do
#          expect(response).to have_rendered 'token_not_found'
#        end
#      end
#    end
#
#    describe '#create' do
#      let!(:enquiry) do
#        enquiry = create(
#          :enquiry,
#          confirmation_token: token,
#          confirmation_token_created: Time.now,
#          customer: customer
#        )
#        enquiry.event = EventDetails.new(date: '1 Dec 2014', time: '1pm')
#        enquiry
#      end
#      let(:customer) { create(:customer, email: 'blah@blah.com') }
#      let(:message) { File.read("#{directory}/email2.txt") }
#      let(:yc_message) { File.read("#{directory}/email3.txt") }
#      let(:make_request) do
#        post :create, token: token, customer_id: customer.id, terms: '1'
#      end
#
#      describe 'valid' do
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#          enquiry.reload
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'changes the enquiry status to be confirmed' do
#          expect(enquiry.status).to eq EnquiryStatus::CONFIRMED
#        end
#
#        it 'sends an email to the customer' do
#          expect(message).to include 'blah@blah.com'
#        end
#
#        it 'sends an email to you chews' do
#          expect(yc_message).to include ENV['WEBSITE_TO_EMAIL']
#        end
#      end
#
#      context 'error' do
#        let(:payment) { instance_double(PaymentProviders::TestPayment) }
#        let!(:enquiry) do
#          enquiry = create(
#            :enquiry,
#            confirmation_token: token,
#            confirmation_token_created: Time.now,
#            customer: customer,
#            payment_method: PaymentMethod::CREDIT_CARD.to_s
#          )
#          enquiry.event = EventDetails.new(date: '1 Dec 2014', time: '1pm')
#          enquiry
#        end
#
#        before do
#          request.env['HTTPS'] = 'on'
#          allow(PaymentCharge)
#            .to receive(:new)
#            .and_raise(PaymentError)
#          make_request
#        end
#
#        it 'returns a 400' do
#          expect(response.status).to eq 400
#        end
#      end
#
#      context 'single invoiced order' do
#        let!(:enquiry) do
#          enquiry = create(
#            :enquiry,
#            confirmation_token: token,
#            confirmation_token_created: Time.now,
#            customer: customer,
#            payment_method: PaymentMethod::SINGLE_EFT_INVOICE.to_s
#          )
#          enquiry.event = EventDetails.new(date: '1 Dec 2014', time: '1pm')
#          enquiry
#        end
#
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#          enquiry.reload
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'changes the enquiry status to be confirmed' do
#          expect(enquiry.status).to eq EnquiryStatus::CONFIRMED
#        end
#
#        it 'sends an email to the customer' do
#          expect(message).to include 'blah@blah.com'
#        end
#
#        it 'sends an email to you chews' do
#          expect(yc_message).to include ENV['WEBSITE_TO_EMAIL']
#        end
#      end
#
#      context 'monthly invoiced order' do
#        let!(:enquiry) do
#          enquiry = create(
#            :enquiry,
#            confirmation_token: token,
#            confirmation_token_created: Time.now,
#            customer: customer,
#            payment_method: PaymentMethod::MONTHLY_EFT_INVOICE.to_s
#          )
#          enquiry.event = EventDetails.new(date: '1 Dec 2014', time: '1pm')
#          enquiry
#        end
#
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#          enquiry.reload
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'changes the enquiry status to be confirmed' do
#          expect(enquiry.status).to eq EnquiryStatus::CONFIRMED
#        end
#
#        it 'sends an email to the customer' do
#          expect(message).to include 'blah@blah.com'
#        end
#
#        it 'sends an email to you chews' do
#          expect(yc_message).to include 'eat@youchews.com'
#        end
#      end
#
#      context 'paypal invoiced order' do
#        let!(:enquiry) do
#          enquiry = create(
#            :enquiry,
#            confirmation_token: token,
#            confirmation_token_created: Time.now,
#            customer: customer,
#            payment_method: PaymentMethod::PAYPAL_INVOICE.to_s
#          )
#          enquiry.event = EventDetails.new(date: '1 Dec 2014', time: '1pm')
#          enquiry
#        end
#
#        before do
#          request.env['HTTPS'] = 'on'
#          make_request
#          enquiry.reload
#        end
#
#        it_behaves_like 'OK response'
#
#        it 'changes the enquiry status to be confirmed' do
#          expect(enquiry.status).to eq EnquiryStatus::CONFIRMED
#        end
#
#        it 'sends an email to the customer' do
#          expect(message).to include 'blah@blah.com'
#        end
#
#        it 'sends an email to you chews' do
#          expect(yc_message).to include 'eat@youchews.com'
#        end
#      end
#    end
#
#    describe '#regenerate' do
#      let!(:enquiry) do
#        create(
#          :enquiry,
#          confirmation_token: token,
#          confirmation_token_created: 2.days.ago
#        )
#      end
#      let(:make_request) { get :regenerate, token: token }
#      let(:message) { File.read("#{directory}/email2.txt") }
#
#      before do
#        request.env['HTTPS'] = 'on'
#        make_request
#      end
#
#      it_behaves_like 'OK response'
#
#      it 'renders the new token sent template' do
#        expect(response).to have_rendered 'regenerate'
#      end
#
#      it 'sends an email to the customer' do
#        expect(message).to include 'Your order has been accepted'
#        expect(message).to include enquiry.customer.email
#      end
#    end
#  end
#end
#
