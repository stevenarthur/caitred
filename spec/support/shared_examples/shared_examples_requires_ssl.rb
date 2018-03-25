shared_examples 'requires ssl' do

  before do
    allow_any_instance_of(described_class)
      .to receive(:require_admin_authentication)
    allow_any_instance_of(described_class)
      .to receive(:power_user?)
      .and_return true
  end

  context 'ssl on' do
    before do
      request.env['HTTPS'] = 'on'
      make_request
    end

    it 'does not redirect' do
      expect(response.status).to be 200
    end

  end

  it_behaves_like 'redirects with no ssl'

end

# do not test for OK response with SSL, only redirect without
shared_examples 'redirects with no ssl' do

  before do
    make_request
  end

  it 'redirects' do
    expect(response.status).to be 301
  end

end
