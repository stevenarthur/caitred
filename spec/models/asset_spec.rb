require 'rails_helper'

class WithAsset
  include Asset
end

describe WithAsset do
  let(:file_name) { 'tmp.txt' }
  let(:file_path) { "#{Rails.root}/app/assets/images/#{file_name}" }
  let(:with_asset) { WithAsset.new }
  let(:asset_dir) { "#{Rails.public_path}/assets" }

  before do
    File.new file_path, 'w'
    Dir.mkdir asset_dir unless Dir.exist? asset_dir
    File.new "#{asset_dir}/#{file_name}", 'w'
  end

  after do
    File.delete file_path
    File.delete "#{asset_dir}/#{file_name}"
    Dir.delete "#{asset_dir}"
  end

  describe '#asset_exists?' do

    context 'no precompilation' do
      before do
        allow(Rails.application.assets).to receive(:find_asset)
          .and_return(file)
      end

      context 'file exists' do
        let(:file) { 'file' }

        it 'returns true' do
          expect(with_asset.asset_exists? file_name).to be true
        end
      end

      context 'file does not exist' do
        let(:file) { nil }

        it 'returns false' do
          expect(with_asset.asset_exists? 'doesnotexist.jpg').to be false
        end
      end
    end

    context 'with precompilation' do
      before do
        allow(Rails.configuration.assets).to receive(:compile)
      end

      context 'file does not exist' do
        it 'returns false ' do
          expect(with_asset.asset_exists? 'doesnotexist.jpg').to be false
        end
      end
    end
  end

end
