require 'rails_helper'

describe Address do

  describe '#one_line' do
    context 'all lines populated' do
      let(:address) do
        create(:address,
               line_1: 'line 1',
               line_2: 'line 2',
               suburb: 'suburb',
               postcode: 'postcode'
               )
      end

      it 'puts the address lines on one' do
        expect(address.one_line).to eq 'Facebook, line 1, line 2, suburb, postcode'
      end
    end

    context 'with blanks' do
      let(:address) do
        create(:address,
               line_1: 'line 1',
               line_2: '',
               suburb: 'suburb',
               postcode: 'postcode'
               )
      end

      it 'skips blank lines' do
        expect(address.one_line).to eq 'Facebook, line 1, suburb, postcode'
      end
    end
  end

end
