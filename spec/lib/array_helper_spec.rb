require 'rails_helper'

describe ArrayHelper do
  let(:source) { [1, 2, 3, 4] }

  it 'gets the first item from the second array that is not in the first' do
    item = ArrayHelper.find_first_unique(source, [2, 5, 6, 7])
    expect(item).to eq 5
  end

end
