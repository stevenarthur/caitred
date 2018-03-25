# encoding: UTF-8

shared_examples 'generates a url slug' do

  let(:url_slug_class) { described_class.new }

  it 'has a property to use to generate a slug' do
    expect(url_slug_class).to respond_to(:generate_url_slug)
  end

end
