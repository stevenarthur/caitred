# encoding: UTF-8

require 'rails_helper'

describe DietaryRequirements do
  let(:expected_properties) do
    [
      :vegetarian,
      :gluten_free
    ]
  end

  it_behaves_like 'a Serializable Attribute'

  describe '#summary' do
    let(:dietary_requirements) do
      DietaryRequirements.load(
        vegetarian: 0,
        gluten_free: 1,
        vegan: 0
      )
    end
    let(:summary) { dietary_requirements.summary }

    it 'does not include non-existent properties' do
      expect(summary).not_to include('no eggs')
    end

    it 'does not include properties set to 0' do
      expect(summary).not_to include('vegetarian')
    end

    it 'includes properties set to 1' do
      expect(summary).to include('gluten free')
    end

    it 'converts underscore to space' do
      expect(summary).to include('gluten free')
    end

    it 'does not include double commas' do
      expect(summary).not_to include(', ,')
    end

  end

end
