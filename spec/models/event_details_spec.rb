# encoding: UTF-8

require 'rails_helper'

describe EventDetails do

  let(:event_details) { EventDetails.load input }
  let(:expected_properties) { [:event_date, :event_time, :attendees] }

  it_behaves_like 'a Serializable Attribute'

  context 'with symbol keys' do
    let(:input) do
      {
        event_date: '12 April 2014',
        event_time: '6pm',
        attendees: '1',
        budget: '$100'
      }
    end

    it 'reads the event date' do
      expect(event_details.event_date.strftime('%d %B %Y')).to eq '12 April 2014'
    end

    it 'reads the event time' do
      expect(event_details.event_time).to eq '6pm'
    end

    it 'reads the attendees' do
      expect(event_details.attendees).to eq '1'
    end

    it 'reads the budget' do
      expect(event_details.budget).to eq '$100'
    end

    it 'outputs a hash' do
      expect(event_details.to_h).to include(event_date: '12 April 2014')
      expect(event_details.to_h).to include(event_time: '6pm')
      expect(event_details.to_h).to include(attendees: '1')
      expect(event_details.to_h).to include(budget: '$100')
    end
  end

  context 'with string keys' do
    let(:input) do
      {
        'event_date' => '12 April 2014',
        'event_time' => '6pm',
        'attendees' => '1',
        'budget' => '$100'
      }
    end

    it 'reads the event date' do
      expect(event_details.event_date.strftime('%d %B %Y')).to eq '12 April 2014'
    end

    it 'reads the event time' do
      expect(event_details.event_time).to eq '6pm'
    end

    it 'reads the attendees' do
      expect(event_details.attendees).to eq '1'
    end

    it 'reads the budget' do
      expect(event_details.budget).to eq '$100'
    end
  end

end
