require 'rails_helper'

describe FoodPartnerHelper, type: :helper do
  describe '#tab_class' do

    context 'tab is set' do
      before do
        assign(:tab, :packageable_items)
      end

      it 'returns active if it matches' do
        expect(helper.tab_class(:packageable_items)).to eq 'active'
      end

      it 'returns nil otherwise' do
        expect(helper.tab_class(:other)).to be_nil
      end

    end
    context 'tab not set' do
      it 'returns active if it matches' do
        expect(helper.tab_class(:food_partner)).to eq 'active'
      end

      it 'returns nil otherwise' do
        expect(helper.tab_class(:menu)).to be_nil
      end

    end

  end
end
