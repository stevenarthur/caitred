
require 'rails_helper'

module Cake
  describe Serializable do
    subject { Object.new.extend Serializable }
    describe 'load and dump' do

      pending 'creates a new budget object'

      it 'can dump to a hash' do
        serialized_attribute = double('serialized')
        allow(serialized_attribute).to receive(:to_h)
        subject.dump(serialized_attribute)
        expect(serialized_attribute).to have_received(:to_h)
      end
    end
  end
end
