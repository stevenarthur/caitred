require 'rails_helper'

module TagParams
  describe Validator do
    let(:validator) { Validator.new }

    describe '#event_type' do
      context 'valid event type' do
        it 'returns the event type object' do
          expect(validator.event_type('breakfast')).not_to be_nil
        end
      end

      context 'invalid event type' do
        it 'returns nil' do
          expect(validator.event_type('nothing')).to be_nil
        end
      end
    end

    describe '#diet' do
      context 'valid diet' do
        it 'returns the diet object' do
          expect(validator.diet('vegan')).not_to be_nil
        end
      end

      context 'invalid diet' do
        it 'returns nil' do
          expect(validator.diet('veganfdfds')).to be_nil
        end
      end
    end

    describe '#menu_tag' do
      before do
        create(:menu_tag, tag: 'hot', is_filter: true)
      end

      context 'valid menu_tag' do
        it 'returns the menu tag object' do
          expect(validator.menu_tag('hot')).not_to be_nil
        end
      end

      context 'invalid menu tag' do
        it 'returns nil' do
          expect(validator.menu_tag('blah')).to be_nil
        end
      end
    end
  end
end
