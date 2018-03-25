require 'rails_helper'

describe PackageableItemsController, type: :controller do
  let(:food_partner) { create(:food_partner) }
  let(:title) { 'something packageable' }
  let(:description) { 'a long description of this item' }
  let(:item_type) { 'equipment' }
  let(:cost) { 4.00 }
  let(:event_types) { %w(Lunch Breakfast) }

  shared_examples 'sets tab' do

    it 'sets the correct tab' do
      expect(assigns(:tab)).to eq :packageable_items
    end

  end

  shared_examples 'sets the item properties' do

    it 'sets the title' do
      expect(packageable_item.title).to eq title
    end

    it 'sets the description' do
      expect(packageable_item.description).to eq description
    end

    it 'sets the cost' do
      expect(packageable_item.cost).to eq cost
    end


    it 'sets the event types' do
      expect(packageable_item.event_type).to eq event_types
    end

    it 'sets the item type' do
      expect(packageable_item.item_type).to eq item_type
    end

    it 'sets the food partner' do
      expect(packageable_item.food_partner).to eq food_partner
    end

  end

  describe '#index' do
    let(:make_request) { get :index, food_partner_id: food_partner.id }

    
    it_behaves_like 'requires admin authentication'

    context 'with packageable items' do
      let!(:item_1) { create(:packageable_item, food_partner: food_partner) }
      let!(:item_2) { create(:packageable_item, food_partner: food_partner) }

      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it_behaves_like 'sets tab'

      it 'has the right number of items' do
        expect(assigns(:packageable_items).size).to be 2
      end

      it 'retrieves the customers' do
        expect(assigns(:packageable_items)).to include item_1
        expect(assigns(:packageable_items)).to include item_2
      end

    end

  end

  describe '#new' do
    let(:make_request) { get :new, food_partner_id: food_partner.id }

    
    it_behaves_like 'requires admin authentication'

    context 'new' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it_behaves_like 'sets tab'

      it 'sets the food partner' do
        expect(assigns(:food_partner)).to eq food_partner
      end
    end
  end

  describe '#create' do
    let(:params) do
      {
        food_partner_id: food_partner.id,
        packageable_item: {
          title: title,
          description: description,
          cost: cost,
          item_type: item_type,
          event_type: event_types
        }
      }
    end
    let(:make_request) { post :create, params }

    describe 'ssl and authentication' do
      it_behaves_like 'redirects when not authenticated'
    end

    describe 'creating a packageable item' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      let(:packageable_item) { PackageableItem.find_by_title(title) }

      it_behaves_like 'sets the item properties'
    end
  end

  describe '#update' do
    let(:packageable_item) { create(:packageable_item) }
    let(:params) do
      {
        food_partner_id: food_partner.id,
        id: packageable_item.id,
        packageable_item: {
          title: title,
          description: description,
          cost: cost,
          item_type: item_type,
          event_type: event_types
        }
      }
    end
    let(:make_request) { post :update, params }

    describe 'ssl and authentication' do
      it_behaves_like 'redirects when not authenticated'
    end

    describe 'updating a packageable item' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
        packageable_item.reload
      end

      it_behaves_like 'sets the item properties'
    end
  end

  describe '#edit' do
    let(:make_request) do
      get :edit, food_partner_id: food_partner.id, id: packageable_item.id
    end
    let(:packageable_item) { create(:packageable_item) }

    
    it_behaves_like 'requires admin authentication'

    context 'edit' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it_behaves_like 'sets tab'

      it 'sets the food partner' do
        expect(assigns(:food_partner)).to eq food_partner
      end

      it 'sets the packageable item' do
        expect(assigns(:packageable_item)).to eq packageable_item
      end
    end
  end

  describe '#destroy' do
    let(:make_request) do
      delete :destroy, food_partner_id: food_partner.id, id: packageable_item.id
    end
    let(:packageable_item) { create(:packageable_item) }

    describe 'ssl and authentication' do
      it_behaves_like 'redirects when not authenticated'
    end

    context 'destroy' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it 'deletes the packageable_item' do
        expect(PackageableItem.exists? packageable_item.id).to be false
      end
    end
  end
end
