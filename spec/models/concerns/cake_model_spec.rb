require 'rails_helper'

class WithCakeModel
  include CakeModel
end

describe WithCakeModel do
  describe '#generate_url_from' do
    let(:url_slugger) { instance_double(Cake::UrlSlugger, generate_url_from: nil) }
    before do
      allow(Cake::UrlSlugger).to receive(:new).and_return(url_slugger)
    end

    it 'creates a new UrlSlugger' do
      WithCakeModel.cake_model do
        generate_url_from :type
      end

      expect(Cake::UrlSlugger).to have_received(:new)
    end

    it 'calls generate_url_from' do
      WithCakeModel.cake_model do
        generate_url_from :type
      end

      expect(url_slugger).to have_received(:generate_url_from)
        .with(:type)
    end
  end

  describe '#featurable' do
    let(:featurable) { instance_double(Cake::Featurable, featurable: nil) }
    let(:block_to_call) { proc {} }

    before do
      allow(Cake::Featurable).to receive(:new).and_return(featurable)
    end

    it 'creates a new Featurable' do
      WithCakeModel.cake_model do
        featurable do
        end
      end

      expect(Cake::Featurable).to have_received(:new)
    end

    it 'calls featurable' do
      WithCakeModel.cake_model do
        featurable do
        end
      end

      expect(featurable).to have_received(:featurable)
    end
  end

  describe '#image_properties' do
    let(:has_images) { instance_double(Cake::HasImages, image_properties: nil) }

    before do
      allow(Cake::HasImages).to receive(:new).and_return(has_images)
    end

    it 'creates a new HasImages' do
      WithCakeModel.cake_model do
        image_properties :main, :blah
      end

      expect(Cake::HasImages).to have_received(:new)
    end

    it 'calls has_images' do
      WithCakeModel.cake_model do
        image_properties :main, :blah
      end

      expect(has_images).to have_received(:image_properties)
        .with :main, :blah
    end

  end
end
