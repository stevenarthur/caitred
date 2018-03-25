# encoding: UTF-8

shared_examples 'has a price' do

  let(:priced_class) { described_class.new price: price }

  shared_examples 'formats price' do
    it 'outputs its price as a string without decimal places' do
      expect(priced_class.price_string).to eq price_string
    end

    it 'outputs the same for display price' do
      expect(priced_class.price_display_string).to eq priced_class.price_string
    end

    it 'is not free' do
      expect(priced_class.free?).to be false
    end
  end

  context 'price is a dollar amount' do
    let(:price) { 10 }
    let(:price_string) { '$10' }
    it_behaves_like 'formats price'
  end

  context 'price is dollars and cents' do
    let(:price) { 10.67 }
    let(:price_string) { '$10.67' }
    it_behaves_like 'formats price'
  end

  context 'price is a float with one decimal place' do
    let(:price) { 10.5 }
    let(:price_string) { '$10.50' }
    it_behaves_like 'formats price'
  end

  context 'price is zero' do
    let(:price) { 0 }

    it 'outputs its price as a string' do
      expect(priced_class.price_string).to eq '$0'
    end

    it 'outputs "free" for display price' do
      expect(priced_class.price_display_string).to eq 'free'
    end

    it 'is free' do
      expect(priced_class.free?).to be true
    end

  end

end
