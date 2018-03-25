shared_examples 'sets the menu properties' do

  it 'sets the title' do
    expect(menu.title).to eq title
  end

  it 'sets the short description' do
    expect(menu.description).to eq description
  end

  it 'sets the price' do
    expect(menu.price).to eq price
  end

  it 'sets the long description' do
    expect(menu.long_description).to eq long_description
  end

  it 'sets the package conditions' do
    expect(menu.package_conditions).to eq package_conditions
  end

  it 'sets the minimum attendees' do
    expect(menu.minimum_attendees).to eq minimum_attendees
  end

  it 'sets the tags' do
    expect(menu.tags).to eq tags
  end

  it 'sets the slug' do
    expect(menu.url_slug).to eq slug
  end

  it 'sets the priority order' do
    expect(menu.priority_order).to eq priority_order
  end

  it 'sets the meta title' do
    expect(menu.meta_title).to eq meta_title
  end

  it 'sets the meta description' do
    expect(menu.meta_description).to eq meta_description
  end

end
