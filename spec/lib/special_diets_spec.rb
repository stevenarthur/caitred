require 'rails_helper'

describe SpecialDiets do

  describe '#names' do
    it 'gets a list of all the diet type names' do
      expect(SpecialDiets.names.size).to be 3
    end

    it 'contains strings' do
      expect(SpecialDiets.names.first).to be_a String
    end
  end

  describe '#all' do
    it 'gets a list of all the diet types' do
      expect(SpecialDiets.all.size).to be 3
    end

    it 'contains EventTypes' do
      expect(SpecialDiets.all.first).to be_a SpecialDiets
    end
  end

  describe '#to_method_name' do
    let(:diet) { SpecialDiets.new('Gluten Free', 'gluten free peeps') }

    it 'gets the right method name for the diet type' do
      expect(diet.to_method_name).to eq 'gluten_free?'
    end
  end

  describe '#to_scope_name' do
    let(:diet) { SpecialDiets.new('Gluten Free', 'gluten free peeps') }

    it 'gets the right scope name for the diet type' do
      expect(diet.to_scope_name).to eq 'gluten_free'
    end
  end

  describe '#slug' do
    let(:diet) { SpecialDiets.new('Gluten Free', 'gluten free peeps') }

    it 'gets the right slug for the diet type' do
      expect(diet.slug).to eq 'gluten-free'
    end
  end

  describe '#find' do
    it 'retrieves the special diet object from the name' do
      expect(SpecialDiets.find('Gluten Free').name).to eq 'Gluten Free'
    end

    it 'returns nil for unrecognised event types' do
      expect(SpecialDiets.find('nothing')).to be_nil
    end

    it 'disregards case' do
      expect(SpecialDiets.find('gluTen FreE')).not_to be_nil
    end

    it 'does not fail with nil' do
      expect(SpecialDiets.find(nil)).to be_nil
    end
  end

  describe '#find_by_slug' do
    it 'retrieves the special diet object from the name' do
      expect(SpecialDiets.find_by_slug('gluten-free').name).to eq 'Gluten Free'
    end

    it 'returns nil for unrecognised event types' do
      expect(SpecialDiets.find_by_slug('nothing')).to be_nil
    end

    it 'disregards case' do
      expect(SpecialDiets.find_by_slug('gluTen-FreE')).not_to be_nil
    end

    it 'does not fail with nil' do
      expect(SpecialDiets.find_by_slug(nil)).to be_nil
    end
  end
end
