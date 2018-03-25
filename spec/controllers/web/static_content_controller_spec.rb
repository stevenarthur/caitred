require 'rails_helper'

module Web
  describe StaticContentController, type: :controller do

    describe '#faqs' do
      before do
        get :faqs
      end

      it_behaves_like 'OK response'

      it 'renders the faqs template' do
        expect(response).to have_rendered 'faqs'
      end
    end

    describe '#privacy' do
      before do
        get :privacy
      end

      it_behaves_like 'OK response'

      it 'renders the privacy template' do
        expect(response).to have_rendered 'privacy'
      end
    end

    describe '#terms' do
      before do
        get :terms
      end

      it_behaves_like 'OK response'

      it 'renders the terms template' do
        expect(response).to have_rendered 'terms'
      end
    end
  end
end
