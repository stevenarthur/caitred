require 'rails_helper'

module Web
  describe PasswordResetController do
    let(:directory) { 'tmp/emails' }
    let(:message) { Mailers::CustomerPasswordResetMail.new(customer, 'http://localhost:3000').message }
    let!(:initial_file_count) do
      FileUtils.mkdir directory unless Dir.exist? directory
      Dir.open(directory).count
    end
    after do
      FileUtils.rm_rf(directory)
    end

    describe '#new' do
      let(:make_request) { get :new }

      
      context 'with ssl' do
        before do
          request.env['HTTPS'] = 'on'
        end

        it_behaves_like 'OK response'
      end
    end

    describe '#create' do
      let(:make_request) { post :create, params }
      let(:params) do
        {
          email: 'x@y.com'
        }
      end

      

      context 'with ssl' do
        before do
          request.env['HTTPS'] = 'on'
        end

        context 'non-existent customer' do
          before do
            make_request
          end

          it "redirects" do
            expect(response.status).to eq 302
          end

          it 'does not send any emails' do
            expect(Dir.open(directory).count).to eq initial_file_count
          end
        end

        context 'customer exists' do
          let!(:customer) { create(:customer, email: 'x@y.com', first_name: 'XX') }
          before do
            make_request
            customer.reload
          end

          it_behaves_like 'OK response'

          it 'sends an email' do
            expect(enqueued_jobs.size).to eq(1) 
            expect(enqueued_jobs[0][:args][0]).to eq "CustomerMailer"
            expect(enqueued_jobs[0][:args][1]).to eq "reset_password"
          end

          it 'sets the password token and date' do
            expect(customer.password_reset_token).not_to be_nil
            expect(customer.reset_token_created).not_to be_nil
          end
        end
      end
    end
  end
end
