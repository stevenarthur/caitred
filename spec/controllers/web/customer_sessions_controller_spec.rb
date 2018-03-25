require 'rails_helper'

module Web
  describe CustomerSessionsController do
    before do
      request.env['HTTPS'] = 'on'
    end

    describe '#create' do
      let(:params) do
        {
          authentication_customer_session: {
            email: 'test@blah.com',
            password: 'blahblah'
          }
        }
      end

      before do
        allow(Authentication::CustomerSession)
          .to receive(:new)
          .and_return(session)
        post :create, params
      end

      context 'valid login' do
        let(:session) do
          session = instance_double(Authentication::CustomerSession)
          allow(session).to receive(:save!)
          allow(session).to receive(:remember_me=)
          session
        end

        it 'saves the current user session' do
          expect(session).to have_received(:save!)
        end

        it 'redirects to the home page' do
          expect(response).to redirect_to(root_path)
        end

      end

      context 'invalid login' do
        let(:session) do
          session = instance_double(Authentication::CustomerSession)
          allow(session).to receive(:save!).and_raise
          allow(session).to receive(:remember_me=)
          session
        end

        it 'redirects to the login page' do
          expect(response).to redirect_to(customer_login_path)
        end

      end
    end

    describe '#destroy' do
      let(:session) do
        session = double
        allow(session).to receive(:destroy)
        session
      end

      before do
        allow(Authentication::CustomerSession).to receive(:find).and_return(session)
        get :destroy
      end

      it 'destroys the current user session' do
        expect(session).to have_received(:destroy)
      end

      it 'redirects' do
        expect(response.status).to eq 302
      end
    end

    describe '#new' do

      context 'normal response' do
        before do
          get :new
        end

        it_behaves_like 'OK response'
      end

      context 'customer is authenticated' do
        let(:session) do
          double(
            Authentication::CustomerSession,
            customer: {}
          )
        end
        before do
          allow(Authentication::CustomerSession)
            .to receive(:find)
            .and_return(session)
          get :new
        end

        it 'redirects to the home page' do
          expect(response).to redirect_to root_path
        end
      end
    end
  end
end
