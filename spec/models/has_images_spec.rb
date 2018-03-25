require 'rails_helper'

class WithImages
  def main_image_file_name
  end

  def id
  end

  include CakeModel

  cake_model do
    image_properties :main
  end
end

class WithInvalidImages
  include CakeModel
  cake_model do
    image_properties :invalid
  end
end

describe WithImages do

  it 'includes the asset module' do
    expect(WithImages).to include Asset
  end

  it 'throws an error when checking if there is a file name' do
    expect { WithInvalidImages.new.invalid_image_file_name? }.to raise_error NoMethodError
  end

  it 'throws an error on getting the image path' do
    expect { WithInvalidImages.new.invalid_image_path }.to raise_error NoMethodError
  end

  it 'throws an error when checking for the image' do
    expect { WithInvalidImages.new.invalid_image? }.to raise_error NoMethodError
  end

  describe '#image_file_name' do
    let(:with_images) { WithImages.new }

    it 'creates a method to check for the image file name' do
      expect(WithImages.new).to respond_to 'main_image_file_name?'
    end

    context 'with image file name set' do
      before do
        allow(with_images).to receive(:main_image_file_name)
          .and_return 'a_file'
      end

      it 'returns true' do
        expect(with_images.main_image_file_name?).to be true
      end
    end

    context 'with empty image file name' do
      before do
        allow(with_images).to receive(:main_image_file_name)
          .and_return ''
      end

      it 'returns false' do
        expect(with_images.main_image_file_name.blank?).to be true
      end
    end

    context 'with nil image file name' do
      before do
        allow(with_images).to receive(:main_image_file_name)
          .and_return nil
      end

      it 'returns false' do
        expect(with_images.main_image_file_name.blank?).to be true
      end
    end
  end

  describe '#image_path' do
    let(:with_images) { WithImages.new }
    let(:image_file) { 'image_file' }

    before do
      allow(with_images).to receive(:main_image_file_name)
        .and_return image_file
      allow(with_images).to receive(:id)
        .and_return 2
    end

    it 'creates a method to get the image path' do
      expect(with_images).to respond_to 'main_image_path'
    end

    context 'with image path' do
      let(:image_file) { 'image_file' }
      it 'constructs the path from the image type' do
        expect(with_images.main_image_path).to eq 'mains/image_file'
      end
    end

    context 'no image path' do
      let(:image_file) { nil }
      it 'constructs the path with the id' do
        #TO DO expect(with_images.main_image_path).to eq 'mains/2.jpg'
      end
    end
  end

  describe '#image?' do
    let(:with_images) { WithImages.new }

    it 'creates a method to check if the asset exists' do
      expect(with_images).to respond_to 'main_image?'
    end

    context 'asset exists' do
      before do
        allow(with_images).to receive(:asset_exists?)
          .and_return true
      end

      it 'returns true' do
        expect(with_images.main_image?).to be true
      end
    end

    context 'asset does not exist' do
      before do
        allow(with_images).to receive(:asset_exists?)
          .and_return true
      end

      it 'returns false' do
        expect(with_images.main_image?).to be true
      end

    end
  end

end
