require 'rails_helper'

module Web
  describe CustomersController do
    let(:directory) { 'tmp/emails' }
    after do
      FileUtils.rm_rf(directory)
    end
    describe '#create_account' do
      let(:email) { 'blah@blah.com' }
      let(:customer) { create(:customer, email: email) }
      let(:params) do
        {
          id: customer.id,
          customer: customer_params
        }
      end
      let(:customer_params) do
        {
          password: 'pass',
          password_confirmation: 'pass',
          email: email,
          first_name: 'name',
          last_name: 'name'
        }
      end
      let(:make_request) { post :create_account, params }

      

      context 'unmatched passwords' do
        before do
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        let(:customer_params) do
          {
            password: 'pass',
            password_confirmation: 'word',
            email: email,
            first_name: 'name',
            last_name: 'name'
          }
        end

        it 'throws an exception' do
        end
      end

      context 'valid passwords' do
        before do
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        it_behaves_like 'OK response'

        it 'sets the password for the customer' do
          expect(customer.crypted_password).not_to be_nil
        end

        it 'logs the customer in' do
          expect(controller.current_customer_session.customer).not_to be_nil
        end

        it 'is still logged in within the expiry time' do
          t = Time.now + 1.hour
          Timecop.travel(t)
          expect(controller.current_customer_session.customer).not_to be_nil
        end

        it 'logs the customer out after the expiry time' do
          t = Time.now + 2.months
          Timecop.travel(t)
          expect(controller.current_customer_session.customer).to be_nil

        end
      end
    end

    describe '#new' do
      before do
        request.env['HTTPS'] = 'on'
        get :new
      end

      it_behaves_like 'OK response'
    end

    describe '#create' do

      let(:params) do
        {
          customer: {
            email: 'blah@blah.com',
            telephone: "0425616397",
            password: 'pass',
            password_confirmation: 'pass',
            first_name: 'john',
            last_name: 'smith'
          }
        }
      end
      let(:make_request) { post :create, params }

      

      context 'authenticated' do

        let(:session) { double(Authentication::CustomerSession, customer: {}) }
        before do
          request.env['HTTPS'] = 'on'
          allow(Authentication::CustomerSession).to receive(:find)
            .and_return(session)
          make_request
        end

        it 'redirects to the root path' do
          expect(response).to redirect_to(root_path)
        end
      end

      context 'new customer' do
        let(:customer) { Customer.find_by_email('blah@blah.com') }
        before do
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'creates an account' do
          expect(customer).not_to be_nil
        end

        it 'logs the customer in' do
          expect(assigns[:current_customer_session]).not_to be_nil
        end
      end

      context 'customer exists but does not have an account' do
        let!(:customer) do
          create(
            :customer,
            email: 'blah@blah.com',
            created_account: false
          )
        end

        before do
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        it_behaves_like 'OK response'

        it 'creates an account from the existing one' do
          expect(customer.created_account).to eq true
        end

        it 'logs the customer in' do
          expect(assigns[:current_customer_session]).not_to be_nil
        end

        it 'sends an email to the customer' do
          expect(enqueued_jobs.size).to eq(1) 
          expect(enqueued_jobs[0][:args][0]).to eq "CustomerMailer"
        end
      end

      context 'password is blank' do
        let(:customer) { Customer.find_by_email('blah@blah.com') }
        let(:params) do
          {
            customer: {
              email: 'blah@blah.com',
              password: '',
              password_confirmation: '',
              first_name: 'john',
              last_name: 'smith'
            }
          }
        end

        before do
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'does not register the customer' do
          expect(customer).to be_nil
        end

        it 'adds an error in to the errors object' do
          expect(flash[:error]).not_to be_nil
        end
      end

      context 'customer is registered' do
        let!(:customer) do
          create(
            :customer,
            email: 'blah@blah.com',
            created_account: true
          )
        end

        before do
          request.env['HTTPS'] = 'on'
          make_request
          customer.reload
        end

        it_behaves_like 'OK response'

        it 'adds an error in to the errors object' do
          expect(flash[:error]).not_to be_nil
        end
      end
    end

    describe '#reset_password' do
      render_views

      let(:token) { SecureRandom.urlsafe_base64 }
      let(:make_request) { get :reset_password, params }
      let(:params) do
        { token: token }
      end

      

      context 'with ssl enabled' do
        before do
          request.env['HTTPS'] = 'on'
        end

        context 'valid token' do
          let!(:customer) do
            create(
              :customer,
              password_reset_token: token,
              reset_token_created: Time.now
            )
          end

          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'displays the form to reset' do
            expect(response).to have_rendered('reset_password')
          end
        end

        context 'expired token' do
          let!(:customer) do
            create(
              :customer,
              password_reset_token: token,
              reset_token_created: Time.now - 3.hours
            )
          end
          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'displays the error page' do
            expect(response).to have_rendered('reset_password_error')
          end
        end

        context 'nonexistent token' do
          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'displays the error page' do
            expect(response).to have_rendered('reset_password_error')
          end
        end
      end
    end

    describe '#do_reset_password' do
      render_views

      let(:token) { SecureRandom.urlsafe_base64 }
      let(:make_request) { get :do_reset_password, params }
      let(:params) do
        {
          token: token,
          password: 'pass',
          password_confirmation: 'pass'
        }
      end

      

      context 'with ssl enabled' do
        before do
          request.env['HTTPS'] = 'on'
        end

        context 'valid token' do
          let!(:customer) do
            create(
              :customer,
              password_reset_token: token,
              reset_token_created: Time.now)
          end

          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'deletes the token' do
            customer.reload
            expect(customer.password_reset_token).to be_nil
            expect(customer.reset_token_created).to be_nil
          end
        end

        context 'valid token but mismatched password' do
          let!(:customer) do
            create(
              :customer,
              password_reset_token: token,
              reset_token_created: Time.now
            )
          end
          let(:params) do
            {
              token: token,
              password: 'pass',
              password_confirmation: 'pass2'
            }
          end
          before do
            make_request
          end

          it_behaves_like 'OK response'

          pending 'does not delete the token' do
            customer.reload
            expect(customer.password_reset_token).not_to be_nil
            expect(customer.reset_token_created).not_to be_nil
          end

          pending 'includes an error in the response' do
            expect(flash[:error]).not_to be_nil
          end

          pending 'renders the original form' do
            expect(response).to have_rendered('reset_password')
          end
        end

        context 'nonexistent token' do
          let(:params) do
            {
              token: '123',
              password: 'pass',
              password_confirmation: 'pass2'
            }
          end

          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'displays the error page' do
            expect(response).to have_rendered('reset_password_error')
          end
        end

        context 'expired token' do
          let!(:customer) do
            create(
              :customer,
              password_reset_token: token,
              reset_token_created: Time.now - 3.hours
            )
          end

          before do
            make_request
          end

          it_behaves_like 'OK response'

          it 'deletes the token' do
            customer.reload
            expect(customer.password_reset_token).to be_nil
            expect(customer.reset_token_created).to be_nil
          end

          it 'displays the error page' do
            expect(response).to have_rendered('reset_password_error')
          end
        end
      end
    end
  end
end
