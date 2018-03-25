require 'rails_helper'

describe EventTypes do

  describe '#find' do
    it 'retrieves the event type name from the url slug' do
      expect(EventTypes.find('afternoon-tea').name).to eq 'Afternoon Tea'
    end

    it 'returns nil for unrecognised event types' do
      expect(EventTypes.find('not_event')).to be_nil
    end

    it 'disregards case' do
      expect(EventTypes.find('AFtErNoon-Tea')).not_to be_nil
      expect(EventTypes.find('AFtErNoon-Tea').name).to eq 'Afternoon Tea'
    end
  end

  describe '#find_by_name' do
    it 'retrieves the event type from the name' do
      expect(EventTypes.find_by_name('afternoon tea').slug).to eq 'afternoon-tea'
    end

    it 'returns nil for unrecognised event types' do
      expect(EventTypes.find_by_name('not a name')).to be_nil
    end

    it 'disregards case' do
      expect(EventTypes.find_by_name('AFtErNoon Tea')).not_to be_nil
      expect(EventTypes.find_by_name('AFtErNoon Tea').slug).to eq 'afternoon-tea'
    end
  end

  describe '#slug' do

    it 'gets the right slug for the event type' do
      expect(EventTypes.new('Morning Tea').slug).to eq 'morning-tea'
    end
  end

  describe '#names' do
    it 'gets a list of all the event type names' do
      expect(EventTypes.names.size).to be 10
    end

    it 'contains strings' do
      expect(EventTypes.names.first).to be_a String
    end
  end

  describe '#all' do
    it 'gets a list of all the event types' do
      expect(EventTypes.all.size).to be 10
    end

    it 'contains EventTypes' do
      expect(EventTypes.all.first).to be_a EventTypes
    end
  end

  describe '#types_map' do
    let(:obj1) { double(event_type: 'Breakfast') }
    let(:obj2) { double(event_type: 'Lunch') }

    it 'maps an array of objects to event types' do
      types_map = EventTypes.map_to_types([obj1, obj2])
      expect(types_map).to include EventTypes.find('breakfast') => [obj1]
      expect(types_map).to include EventTypes.find('lunch') => [obj2]
    end

  end

end
