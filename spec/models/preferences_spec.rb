require 'rails_helper'

describe Preferences do
  let(:expected_properties) do
    [
      :opt_out,
      :communication_method
    ]
  end

  it_behaves_like 'a Serializable Attribute'

  it 'returns true for opt out if the property is 1' do
    preferences = Preferences.load opt_out: 1
    expect(preferences.opt_out).to eq true
  end

  it 'returns false for opt out if it is not 1' do
    preferences = Preferences.load opt_out: 0
    expect(preferences.opt_out).to eq false
  end
end
