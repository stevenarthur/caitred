# encoding: UTF-8

require 'rails_helper'

shared_examples 'editing' do
  let(:current_user) { create(:admin_user, is_power_user: true) }
  before do
    allow_any_instance_of(AdminUsersController)
      .to receive(:current_user)
      .and_return current_user
    request.env['HTTPS'] = 'on'
    make_request
  end

  it 'sets the form type' do
    expect(assigns(:form_type)).to eq form_type
  end

  it 'edits the correct user' do
    expect(assigns(:user).id).to eq current_user.id
  end

  it 'renders the correct template' do
    expect(response).to have_rendered(template)
  end

end

shared_examples 'updates properties' do

  it 'sets the first name' do
    expect(user.first_name).to eq 'Bananas'
  end

  it 'sets the last name' do
    expect(user.last_name).to eq 'in Pyjamas'
  end

  it 'sets the email' do
    expect(user.email_address).to eq 'blah@blah.com'
  end

  it 'sets the username' do
    expect(user.username).to eq 'bananarama'
  end

  it 'sets the power user switch' do
    expect(user.is_power_user).to eq false
  end

end

describe AdminUsersController, type: :controller do

  describe '#new' do
    let(:make_request) { get :new }

    
    it_behaves_like 'requires power user'

  end

  describe '#create' do
    let(:user_params) do
      {
        first_name: 'Bananas',
        last_name: 'in Pyjamas',
        username: 'bananarama',
        password: 'yellow',
        password_confirmation: 'yellow',
        email_address: 'blah@blah.com',
        mobile_number: '012345',
        is_power_user: false
      }
    end
    let(:make_request) { post :create, params }
    let(:params) do
      {
        authentication_admin_user: user_params
      }
    end

    it_behaves_like 'checks for power user'

    describe 'creating a user' do
      let(:power_user) { create(:admin_user, is_power_user: true) }
      before do
        allow_any_instance_of(AdminUsersController)
          .to receive(:current_user)
          .and_return power_user
        request.env['HTTPS'] = 'on'
        make_request
      end

      context 'correct params' do
        let(:user) { Authentication::AdminUser.find_by_first_name 'Bananas' }

        it_behaves_like 'temporary redirect'

        it 'creates a new admin user' do
          expect(Authentication::AdminUser.all.count).to eq 2
        end

        it_behaves_like 'updates properties'

      end

      context 'with missing password' do
        let(:error_message) { 'Could not create a new user.' }
        let(:user_params) do
          {
            password: ''
          }
        end

        it_behaves_like 'bad request'

        it 'renders the new template' do
          expect(response).to have_rendered('new')
        end
      end

      context 'mismatched passwords' do
        let(:error_message) { 'Could not create a new user.' }
        let(:user_params) do
          {
            password: 'longenough',
            password_confirmation: 'somethingelse'
          }
        end

        it_behaves_like 'bad request'

        it 'renders the new template' do
          expect(response).to have_rendered('new')
        end
      end

    end

  end

  describe '#edit' do
    let(:template) { 'edit' }
    let(:form_type) { 'edit_profile' }
    let(:current_user) { create(:admin_user, is_power_user: true) }
    let(:make_request) { get :edit, id: current_user.id }

    
    it_behaves_like 'requires power user'
    it_behaves_like 'editing'

  end

  describe '#reset_password' do
    let(:template) { 'reset_password' }
    let(:form_type) { 'reset_password' }
    let(:current_user) { create(:admin_user, is_power_user: true) }
    let(:make_request) { get :reset_password, id: current_user.id }

    
    it_behaves_like 'requires power user'
    it_behaves_like 'editing'

  end

  describe '#edit_my_profile' do
    let(:template) { 'edit' }
    let(:form_type) { 'my_profile' }
    let(:current_user) { create(:admin_user) }
    let(:make_request) { get :edit_my_profile, id: current_user.id }

    
    it_behaves_like 'redirects when not authenticated'
    it_behaves_like 'editing'

  end

  describe '#reset_my_password' do
    let(:template) { 'reset_password' }
    let(:form_type) { 'reset_my_password' }
    let(:current_user) { create(:admin_user) }
    let(:make_request) { get :reset_my_password, id: current_user.id }

    
    it_behaves_like 'redirects when not authenticated'
    it_behaves_like 'editing'

  end

  describe '#index' do
    let(:make_request) { get :index }

    
    it_behaves_like 'requires power user'

    describe 'retrieving users' do
      let!(:current_user) { create(:admin_user, is_power_user: true) }
      before do
        allow_any_instance_of(AdminUsersController)
          .to receive(:current_user)
          .and_return current_user
        request.env['HTTPS'] = 'on'
        make_request
      end
      let!(:admin_user_1) { create(:admin_user) }
      let!(:admin_user_2) { create(:admin_user) }

      it 'retrieves the right amount of users' do
        # 2 plus the current user
        expect(assigns[:users].size).to be 3
      end

      it 'retrieves all of the users' do
        expect(assigns[:users]).to include admin_user_1
        expect(assigns[:users]).to include admin_user_2
      end
    end

  end

  describe '#update' do
    let!(:user_to_update) { create(:admin_user) }
    let(:user_params) do
      {
        first_name: 'Bananas',
        last_name: 'in Pyjamas',
        username: 'bananarama',
        password: 'yellow',
        password_confirmation: 'yellow',
        email_address: 'blah@blah.com',
        mobile_number: '012345',
        is_power_user: false
      }
    end
    let(:make_request) { patch :update, params }
    let(:params) do
      {
        authentication_admin_user: user_params,
        id: user_to_update.id,
        form_type: form_type
      }
    end
    let(:form_type) { 'edit_profile' }

    it_behaves_like 'checks for power user'

    describe 'updating a user' do
      let(:power_user) { create(:admin_user, is_power_user: true) }
      before do
        allow_any_instance_of(AdminUsersController)
          .to receive(:current_user)
          .and_return power_user
        request.env['HTTPS'] = 'on'
        make_request
      end

      context 'correct params' do
        let(:user) { Authentication::AdminUser.find_by_first_name 'Bananas' }

        it_behaves_like 'temporary redirect'
        it_behaves_like 'updates properties'

      end

      context 'mismatched passwords' do
        let(:user_params) do
          {
            password: 'longenough',
            password_confirmation: 'somethingelse'
          }
        end

        it_behaves_like 'bad request'

        it 'renders the edit template' do
          expect(response).to have_rendered('edit')
        end
      end

      context 'update password' do
        let(:form_type) { 'reset_password' }

        it 'redirects to update password' do
          expect(response).to redirect_to reset_password_path
        end

        it 'displays a message to say password is updated' do
          expect(flash[:success]).to eq 'Password reset'
        end

      end

      context 'update my profile' do
        let(:form_type) { 'my_profile' }

        it 'redirects to update password' do
          expect(response).to redirect_to edit_my_profile_path
        end

        it 'displays a message to say password is updated' do
          expect(flash[:success]).to eq 'Profile updated'
        end

      end

      context 'update my password' do
        let(:form_type) { 'reset_my_password' }

        it 'redirects to update password' do
          expect(response).to redirect_to reset_my_password_path
        end

        it 'displays a message to say password is updated' do
          expect(flash[:success]).to eq 'Password reset'
        end

      end

    end

  end

  describe '#destroy' do
    let!(:user) { create(:admin_user) }
    let(:make_request) { delete :destroy, id: user.id }

    it_behaves_like 'checks for power user'

    describe 'deleting the user' do
      let(:power_user) { create(:admin_user, is_power_user: true) }
      before do
        allow_any_instance_of(AdminUsersController)
          .to receive(:current_user)
          .and_return power_user
        request.env['HTTPS'] = 'on'
        make_request
      end

      it 'deletes the user' do
        expect(Authentication::AdminUser.find_by_id(user.id)).to be_nil
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to users_path
      end
    end

  end

end
