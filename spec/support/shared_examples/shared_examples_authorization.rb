shared_examples 'forbids authenticated user' do
  let(:normal_user) { create(:admin_user, is_power_user: false) }
  before do
    allow_any_instance_of(described_class)
      .to receive(:current_user)
      .and_return(normal_user)
    make_request
  end

  it 'sets the status to 403' do
    expect(response.status).to eq 403
  end

  it 'renders the login page' do
    expect(response).to have_rendered 'shared/forbidden'
  end

end

shared_examples 'redirects when not authenticated' do
  before do
    request.env['HTTPS'] = 'on'
    make_request
  end

  it 'redirects' do
    expect(response.status).to be 302
  end

end

shared_examples 'requires admin authentication' do

  before do
    request.env['HTTPS'] = 'on'
  end

  context 'authenticated' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:require_admin_authentication)
      make_request
    end

    it 'does not redirect' do
      expect(response.status).to be 200
    end

  end

  it_behaves_like 'redirects when not authenticated'
end

shared_examples 'requires power user' do
  let(:power_user) { create(:admin_user, is_power_user: true) }

  before do
    request.env['HTTPS'] = 'on'
  end

  it_behaves_like 'forbids authenticated user'
  it_behaves_like 'redirects when not authenticated'

  context 'power user' do
    before do
      allow_any_instance_of(described_class)
        .to receive(:current_user)
        .and_return(power_user)
      make_request
    end

    it 'does not redirect' do
      expect(response.status).to be 200
    end

  end

end

shared_examples 'checks for power user' do
  let(:normal_user) { create(:admin_user, is_power_user: false) }

  before do
    request.env['HTTPS'] = 'on'
  end

  it_behaves_like 'forbids authenticated user'
  it_behaves_like 'redirects when not authenticated'

end
