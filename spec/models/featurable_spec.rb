require 'rails_helper'

class StubbedModel
  def self.scope(*_args)
  end
  def self.with_tag(_tag)
    [1, 2, 3, 4]
  end
  include CakeModel

  cake_model do
    featurable do |results|
      results
    end
  end
end

describe StubbedModel do
  it 'defines a featured method' do
    expect(StubbedModel).to respond_to :featured
  end

  it 'limits the results passed back' do
    expect(StubbedModel.featured(1).size).to eq 1
  end
end
