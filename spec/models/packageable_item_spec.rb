describe PackageableItem do

  describe 'scopes' do

    describe '#by_food_partner' do
      let(:food_partner1) { create(:food_partner) }
      let(:food_partner2) { create(:food_partner) }
      let!(:packageable_item_1) { create(:packageable_item, food_partner: food_partner1) }
      let!(:packageable_item_2) { create(:packageable_item, food_partner: food_partner1) }
      let!(:packageable_item_3) { create(:packageable_item, food_partner: food_partner2) }
      let(:results) { PackageableItem.by_food_partner(food_partner1) }

      it 'retrieves the right number of menus' do
        expect(results.size).to be 2
      end

      it 'retrieves the packageable items' do
        expect(results).to include packageable_item_1
        expect(results).to include packageable_item_2
      end

      it 'does not include the other partners packageable items' do
        expect(results).not_to include packageable_item_3
      end
    end

    describe '#by_food_partner_and_title' do
      let(:food_partner1) { create(:food_partner) }
      let(:food_partner2) { create(:food_partner) }
      let(:title) { 'something' }
      let!(:packageable_item_1) do
        create(:packageable_item, food_partner: food_partner1, title: title)
      end
      let!(:packageable_item_2) do
        create(:packageable_item, food_partner: food_partner1, title: 'other')
      end
      let!(:packageable_item_3) do
        create(:packageable_item, food_partner: food_partner2, title: title)
      end
      let(:results) { PackageableItem.by_food_partner(food_partner1).with_title(title) }

      it 'retrieves the right number of menus' do
        expect(results.size).to be 1
      end

      it 'retrieves the packageable items' do
        expect(results).to include packageable_item_1
      end

      it 'does not include the other partners packageable items' do
        expect(results).not_to include packageable_item_2
        expect(results).not_to include packageable_item_3
      end
    end

    describe 'dietary_properties' do
      let!(:meat_item) { create(:meat_item) }
      let!(:vegan_item) { create(:vegan_item) }
      let!(:gf_item) { create(:gf_item) }
      let!(:non_gf_item) { create(:non_gf_item) }

      describe '#vegetarian' do
        it 'includes veggie items' do
          expect(PackageableItem.vegetarian).to include(vegan_item)
        end

        it 'does not include meat items' do
          expect(PackageableItem.vegetarian).not_to include(meat_item)
        end
      end

      describe '#vegan' do
        it 'includes vegan items' do
          expect(PackageableItem.vegan).to include(vegan_item)
        end

        it 'does not include meat items' do
          expect(PackageableItem.vegan).not_to include(meat_item)
        end
      end

      describe '#gluten_free' do
        it 'includes gluten free items' do
          expect(PackageableItem.gluten_free).to include(gf_item)
        end

        it 'does not include meat items' do
          expect(PackageableItem.gluten_free).not_to include(non_gf_item)
        end
      end
    end

    describe 'types and food partner' do
      let(:food_partner1) { create(:food_partner) }
      let(:food_partner2) { create(:food_partner) }
      let!(:packageable_item_1) do
        create(:packageable_item, food_partner: food_partner1, item_type: 'food')
      end
      let!(:packageable_item_2) do
        create(:packageable_item, food_partner: food_partner1, item_type: 'equipment')
      end
      let!(:packageable_item_3) do
        create(:packageable_item, food_partner: food_partner2, item_type: 'food')
      end
      let!(:packageable_item_4) do
        create(:packageable_item, food_partner: food_partner2, item_type: 'equipment')
      end

      it 'retrieves the food items' do
        results = PackageableItem.by_food_partner(food_partner1).food
        expect(results.size).to be 1
        expect(results).to include packageable_item_1
      end

      it 'retrieves the equipment items' do
        results = PackageableItem.by_food_partner(food_partner2).equipment
        expect(results.size).to be 1
        expect(results).to include packageable_item_4
      end

    end

  end

  describe '#cost_string' do
    let(:packageable_item) do
      build(:packageable_item, cost: 5.5)
    end

    it 'formats the cost string' do
      expect(packageable_item.cost_string).to eq '$5.50'
    end
  end

  describe 'dietary descriptions' do
    let(:packageable_item) do
      build(:packageable_item, vegetarian: true, vegan: true, gluten_free: true)
    end

    describe '#dietary_acronyms' do
      it 'returns a string of the dietary requirements' do
        expect(packageable_item.dietary_acronyms).to eq '(v, vg, gf)'
      end
    end

    describe '#dietary_desc' do
      it 'returns a string of the descriptions' do
        expect(packageable_item.dietary_desc).to eq 'Vegetarian, Vegan, Gluten Free'
      end
    end

    describe '#suitable for' do
      it 'returns a string of the group names' do
        expect(packageable_item.suitable_for)
          .to eq 'vegetarians and vegans and people who do not eat gluten'
      end
    end
  end

  describe 'validation and defaults' do

    context 'blank title' do
      let(:packageable_item) { build(:packageable_item, title: nil) }

      it 'requires the title' do
        expect(packageable_item.valid?).to be false
      end
    end

    context 'blank cost' do
      let(:packageable_item) { build(:packageable_item, cost: nil) }

      it 'requires the cost' do
        expect(packageable_item.valid?).to be false
      end
    end

    context 'blank item type' do
      let(:packageable_item) { build(:packageable_item, item_type: nil) }

      it 'does not cause an invalid object' do
        expect(packageable_item.valid?).to be true
      end

      it 'defaults to be food' do
        packageable_item.save!
        expect(packageable_item.item_type).to eq 'food'
      end
    end
  end

  describe '#to_hash' do
    let(:packageable_item) { create(:packageable_item) }
    let(:hashed_item) { packageable_item.to_hash }

    it 'contains the id' do
      expect(hashed_item[:id]).to eq packageable_item.id
    end

    it 'contains the title' do
      expect(hashed_item[:title]).to eq packageable_item.title
    end

    it 'contains the original cost' do
      expect(hashed_item[:cost]).to eq packageable_item.cost
    end

    it 'contains the price' do
      expect(hashed_item[:cost_to_youchews]).to eq packageable_item.cost_to_youchews
    end
  end
end
