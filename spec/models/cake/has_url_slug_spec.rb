# encoding: UTF-8

require 'rails_helper'

class WithUrlSlug
  def self.find_by_url_slug
    nil
  end

  def self.before_save(_sym)
  end

  include CakeModel
  cake_model do
    generate_url_from :name
  end
  attr_accessor :name
end

describe WithUrlSlug do
  before do
    allow(WithUrlSlug).to receive(:find_by_url_slug).and_return nil
  end

  let(:url_slug) do
    with_url_slug = WithUrlSlug.new
    with_url_slug.name = name
    with_url_slug.generate_url_slug
  end

  it_behaves_like 'generates a url slug'

  shared_examples 'cleans the name' do

    pending 'turns name into a suitable url slug' do
      expect(url_slug).to eq cleaned_name
    end

  end

  context 'cleaning the name' do
    let(:cleaned_name) { 'name' }

    context 'simple name stays the same' do
      let(:name) { 'name' }
      it_behaves_like 'cleans the name'
    end

    context 'name with spaces cleans spaces' do
      let(:name) { 'n a m e' }
      let(:cleaned_name) { 'n-a-m-e' }
      it_behaves_like 'cleans the name'
    end

    context 'name with special characters removes them' do
      let(:name) { 'n^*)*()&^$a#_{)+}ME' }
      it_behaves_like 'cleans the name'
    end

  end

  context 'empty name' do
    let(:cleaned_name) { '-1' }

    context 'name is nil adds a number' do
      let(:name) { nil }
      it_behaves_like 'cleans the name'
    end

    context 'empty name appends a number' do
      let(:name) { '' }
      it_behaves_like 'cleans the name'
    end

  end

  context 'duplicated name appends a number' do
    let(:name) { 'my name' }
    let(:cleaned_name) { 'my-name-1' }

    before do
      allow(WithUrlSlug).to receive(:find_by_url_slug)
        .with('my-name')
        .and_return WithUrlSlug.new
    end

    it_behaves_like 'cleans the name'
  end
end

class MissingMethodUrlSlug
  def self.before_save(_sym)
  end
  include CakeModel
  attr_accessor :name
end

describe MissingMethodUrlSlug do
  it 'raises an error when the find_by_url_slug class method is missing' do
    expect do
      MissingMethodUrlSlug.cake_model do
        generate_url_from :name
      end
    end.to raise_error NoMethodError
  end
end
