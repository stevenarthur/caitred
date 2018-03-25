require 'rails_helper'

describe ApplicationHelper, type: :helper do

  describe '#flash_class' do

    it 'is alert-info for notice' do
      expect(helper.flash_class('notice')).to eq 'alert alert-info'
    end

    it 'is alert-success for success' do
      expect(helper.flash_class('success')).to eq 'alert alert-success'
    end

    it 'is alert-danger for error' do
      expect(helper.flash_class('error')).to eq 'alert alert-danger'
    end

    it 'is alert-danger for alert' do
      expect(helper.flash_class('alert')).to eq 'alert alert-danger'
    end

    it 'is blank by default' do
      expect(helper.flash_class('')).to be_nil
    end

  end

  describe '#days_from_now' do
    before do
      Timecop.freeze(Time.local(2014, 6, 16))
    end

    after do
      Timecop.return
    end

    it 'counts between two week days' do
      expect(helper.days_from_now(2)).to eq Time.local(2014, 6, 18)
    end

    it 'counts over a weekend' do
      expect(helper.days_from_now(7)).to eq Time.local(2014, 6, 25)
    end

  end

  describe 'cookie domain' do

    it 'is always youchews.com' do
      expect(helper.cookie_domain).to eq 'youchews.com'
    end
  end

  describe 'bootstrap_label_tag' do

    it 'adds the bootstrap class when there are other classes' do
      label = helper.bootstrap_label_tag(
        'name',
        'content',
        class: 'some-class another-class'
      )
      expect(label).to include 'class="some-class another-class control-label"'
    end

    it 'adds the bootstrap class when there are other classes' do
      label = helper.bootstrap_label_tag(
        'name',
        'content',
        class: 'some-class another-class'
        )
      expect(label).to include 'class="some-class another-class control-label"'
    end

    it 'adds the bootstrap class when there are no other classes' do
      label = helper.bootstrap_label_tag('name', 'content', {})
      expect(label).to include 'class="control-label"'
    end

    it 'adds the bootstrap class when there are no options passed' do
      label = helper.bootstrap_label_tag('name', 'content')
      expect(label).to include 'class="control-label"'
    end
  end

  describe '#current_page' do
    let(:params) do
      {
        controller: controller_name
      }
    end
    before do
      allow(helper).to receive(:params).and_return(params)
    end

    context 'menus' do
      let(:controller_name) { 'web/menus' }

      it 'is menus' do
        expect(helper.current_page).to eq :menus
      end
    end

    context 'enquiry' do
      let(:controller_name) { 'enquiries' }

      it 'is enquiry' do
        expect(helper.current_page).to eq :enquiry
      end
    end

    context 'welcome' do
      let(:controller_name) { 'welcome' }

      it 'is home' do
        expect(helper.current_page).to eq :home
      end
    end

    context 'static_content' do
      let(:controller_name) { 'static_content' }

      it 'is static' do
        expect(helper.current_page).to eq :static
      end
    end

    context 'specials' do
      let(:params) do
        {
          controller: 'web/specials',
          action: action
        }
      end

      context 'christmas' do
        let(:action) { 'christmas' }

        it 'is static' do
          expect(helper.current_page).to eq 'christmas'
        end
      end

      context 'food_experiences' do
        let(:action) { 'food_experiences' }

        it 'is static' do
          expect(helper.current_page).to eq 'food_experiences'
        end
      end
    end

  end

  describe '#word_for_people' do
    context '1' do
      it 'is person' do
        expect(helper.word_for_people(1)).to eq 'person'
      end
    end

    context '> 1' do
      it 'is people' do
        expect(helper.word_for_people(5)).to eq 'people'
      end
    end
  end

  describe '#price string' do
    it 'returns (free) if the price is free' do
      expect(helper.price_string('free')).to eq '(free)'
    end

    it 'returns the price plus per person* if the price is not 0' do
      expect(helper.price_string('X')).to eq '(X per person*)'
    end
  end

  describe '#include_facebook?' do
    it 'returns false if it is not set' do
      expect(helper.include_facebook?).to eq false
    end

    context 'set to true' do
      before do
        assign(:include_facebook, true)
      end

      it 'returns true' do
        expect(helper.include_facebook?).to eq true
      end
    end
  end

  describe '#livechat?' do
    let(:params) do
      {
        controller: controller_name
      }
    end
    before do
      allow(helper).to receive(:params).and_return(params)
    end

    context 'welcome controller' do
      let(:controller_name) { 'welcome' }

      it 'returns false' do
        expect(helper.livechat?).to eq false
      end
    end

    context 'other controller' do
      let(:controller_name) { 'food_experiences' }

      it 'returns true' do
        expect(helper.livechat?).to eq true
      end
    end
  end
end
