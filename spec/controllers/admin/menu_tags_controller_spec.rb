require 'rails_helper'

module Admin
  describe MenuTagsController do
    describe '#index' do
      let(:make_request) { get :index }

      
      it_behaves_like 'requires admin authentication'

      context 'authenticated' do
        before do
          create(:menu_tag)
          allow_any_instance_of(MenuTagsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it_behaves_like 'OK response'

        it 'renders the index template' do
          expect(response).to have_rendered('index')
        end

        it 'gets all the menu tags' do
          expect(assigns[:menu_tags]).not_to be_nil
        end
      end
    end

    describe '#generate_tags' do
      let(:make_request) { post :generate_tags }

      it_behaves_like 'redirects when not authenticated'

      context 'authenticated' do
        before do
          allow(MenuTagGenerator).to receive(:generate)
          allow_any_instance_of(MenuTagsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
        end

        it 'redirects to the index page' do
          expect(response).to redirect_to admin_menu_tags_path
        end

        it 'calls the menu tag generator to regenerate tags' do
          expect(MenuTagGenerator).to have_received(:generate)
        end
      end
    end

    describe '#save_all' do
      let(:menu_tag_1) { create(:menu_tag, is_filter: false) }
      let(:menu_tag_2) { create(:menu_tag, is_filter: false) }
      let(:params) do
        {
          filters: [menu_tag_1.id]
        }
      end
      let(:make_request) { post :save_all, params }

      it_behaves_like 'redirects when not authenticated'

      context 'authenticated' do
        before do
          allow_any_instance_of(MenuTagsController)
            .to receive(:require_admin_authentication)
          request.env['HTTPS'] = 'on'
          make_request
          menu_tag_1.reload
          menu_tag_2.reload
        end

        it 'redirects to the index page' do
          expect(response).to redirect_to admin_menu_tags_path
        end

        it 'calls updates the filter attributes for those set to true' do
          expect(menu_tag_1.is_filter).to eq true
        end

        it 'does not update the filter attribute for those set to false' do
          expect(menu_tag_2.is_filter).to eq false
        end
      end
    end
  end
end
