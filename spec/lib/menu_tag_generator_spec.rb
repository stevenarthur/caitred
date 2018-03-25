require 'rails_helper'

describe MenuTagGenerator do
  describe '#generate' do
    before do
      create(:menu_tag, tag: 'old', is_filter: true)
      create(:menu_tag, tag: 'pink')
      create(:menu, tags: %w(pink green))
      create(:menu, tags: ['blue'])
      MenuTagGenerator.generate
    end

    pending'creates a new tag for all the ones attached to menus' do
      expect(MenuTag.find_by_tag('green')).not_to be_nil
      expect(MenuTag.find_by_tag('blue')).not_to be_nil
    end

    pending'does not create duplicate tags' do
      expect(MenuTag.where(tag: 'pink').size).to eq 1
    end

    pending'updates tags that are marked as filters if they have no matching menus' do
      expect(MenuTag.find_by_tag('old').is_filter).to be false
    end
  end
end
