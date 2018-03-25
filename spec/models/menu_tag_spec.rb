require 'rails_helper'

describe MenuTag do

  describe 'scope #filters' do
    let!(:menu_tag_1) { create(:menu_tag, is_filter: false) }
    let!(:menu_tag_2) { create(:menu_tag, is_filter: true) }
    let(:filtered_tags) { MenuTag.filters }

    it 'only returns menu tags marked as filters' do
      expect(filtered_tags.size).to eq 1
    end

    it 'does not include non-filters' do
      expect(filtered_tags).not_to include(menu_tag_1)
    end
  end

  describe '#to_s' do
    let(:menu_tag) { create(:menu_tag, tag: 'my tag') }

    it 'uses the tag' do
      expect(menu_tag.to_s).to eq 'my tag'
    end
  end

end
