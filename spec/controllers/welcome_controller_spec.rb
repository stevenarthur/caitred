require 'rails_helper'

describe WelcomeController, type: :controller do
  before do
    get :index
  end

  it_behaves_like 'OK response'

  it 'renders the index template' do
    expect(response).to have_rendered 'index'
  end
end
