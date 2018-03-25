shared_examples 'a Serializable Attribute' do
  let(:included_modules) { described_class.singleton_class.included_modules }

  it 'extends Serializable module' do
    expect(included_modules).to include Cake::Serializable
  end

  it 'extends ActiveModel::Naming module' do
    expect(included_modules).to include ActiveModel::Naming
  end

  it 'contains allowed params' do
    expect(described_class).to respond_to(:allowed_params)
  end

  it 'responds to expected properties' do
    expected_properties.each do |property|
      expect(described_class.new({})).to respond_to property
    end
  end

  it 'outputs a hash' do
    expect(described_class.new({}).to_h).to be_a(Hash)
  end

end
