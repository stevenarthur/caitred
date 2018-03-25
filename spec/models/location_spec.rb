require 'rails_helper'

describe Location do

  describe '#slug' do
    it 'returns the name downcased' do
      expect(Location.new('Sydney').slug).to eq 'sydney'
    end
  end

  describe '#find_by_slug' do
    it 'finds the matching location from the list' do
      expect(Location.find_by_slug('sydney')).to be_a Location
      expect(Location.find_by_slug('sydney').name).to eq 'Sydney'
    end

    it 'returns sydney if the param is nil' do
      expect(Location.find_by_slug(nil)).to eq Location.sydney
    end

    it 'returns sydney if the param is blank' do
      expect(Location.find_by_slug('')).to eq Location.sydney
    end

    it 'returns sydney if the param is not recognised' do
      expect(Location.find_by_slug('blah')).to eq Location.sydney
    end
  end

  describe '#sydney' do
    it 'returns the sydney location' do
      expect(Location.sydney).to be_a Location
      expect(Location.sydney.name).to eq 'Sydney'
    end
  end
end
