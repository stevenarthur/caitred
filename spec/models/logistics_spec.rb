# encoding: UTF-8

require 'rails_helper'

describe Logistics do
  let(:expected_properties) do
    [
      :parking_information
    ]
  end

  it_behaves_like 'a Serializable Attribute'

end
