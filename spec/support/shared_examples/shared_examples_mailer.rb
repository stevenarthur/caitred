shared_examples 'a mailer' do
  let(:message) { mail.message }
  let(:message_content) { 'Email content.' }
  let(:haml) do
    haml = instance_double(Haml::Engine)
    allow(haml).to receive(:render).and_return message_content
    haml
  end

  before do
    allow(Haml::Engine).to receive(:new).and_return haml
  end

  after do
    FileUtils.rm_rf('tmp/emails')
  end

  it 'returns a message object' do
    expect(message).not_to be_nil
  end

  it 'sets the from email address' do
    expect(message['from_email']).to eq from_email
  end

  it 'sets the from email name' do
    expect(message['from_name']).to eq from_name
  end

  it 'sets the to email from the supplier' do
    expect(message['to'].first['email']).to eq email
  end

  it 'sets the to email name from the supplier' do
    expect(message['to'].first['name']).to eq name
  end

  it 'attaches the logo image' do
    expect(message['images'].length).to be >= 1
  end

  it 'sets the subject' do
    expect(message['subject']).to eq subject
  end

  it 'uses the correct email template' do
    message
    expect(Haml::Engine).to have_received(:new).with(expected_template)
  end

  it 'creates the html from the template' do
    expect(message['html']).to eq message_content
  end

end
