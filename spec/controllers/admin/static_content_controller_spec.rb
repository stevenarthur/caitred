require 'rails_helper'

module Admin
  describe StaticContentController, type: :controller do
    describe '#credits' do
      before do
        allow_any_instance_of(StaticContentController)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        get :admin_credits
      end

      it_behaves_like 'OK response'

      it 'renders the admin_credits template' do
        expect(response).to have_rendered 'admin_credits'
      end
    end
  end
end
