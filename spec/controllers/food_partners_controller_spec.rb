require 'rails_helper'

# This spec is for Cake and not the frontend.
shared_examples 'sets food partner properties' do

  it 'sets the company name' do
    expect(food_partner.company_name).to eq 'Waterloo'
  end

  it 'sets the email' do
    expect(food_partner.email).to eq 'blah@blah.com'
  end

  it 'sets the phone number' do
    expect(food_partner.phone_number).to eq '12345'
  end

  it 'sets the contact first name' do
    expect(food_partner.contact_first_name).to eq 'Will'
  end

  it 'sets the contact last name' do
    expect(food_partner.contact_last_name).to eq 'Young'
  end

  it 'sets the minimum spend' do
    expect(food_partner.minimum_spend).to eq 10
  end

  it 'sets the minimum attendees' do
    expect(food_partner.minimum_attendees).to eq 5
  end

  it 'sets the maximum attendees' do
    expect(food_partner.maximum_attendees).to eq 100
  end

  it 'sets the delivery cost' do
    expect(food_partner.delivery_cost).to eq 50
  end

  it 'sets the delivery text' do
    expect(food_partner.delivery_text).to eq 'free'
  end

  it 'sets the availability text' do
    expect(food_partner.availability_text).to eq 'every day'
  end

  it 'sets the url slug' do
    expect(food_partner.url_slug).to eq 'waterloo'
  end

  it 'sets the lead time in days' do
    expect(food_partner.lead_time_hours).to eq 72
  end

  it 'sets the lowest priced dish' do
    expect(food_partner.lowest_price_dish).to eq 12
  end

end

describe FoodPartnersController, type: :controller do

  describe '#index' do
    let(:make_request) { get :index }

    
    it_behaves_like 'requires admin authentication'

    context 'with food partners' do
      let!(:food_partner_1) { create(:food_partner) }
      let!(:food_partner_2) { create(:food_partner) }

      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        get :index
      end

      # Wrong
      it 'has the right number of food partners' do
        expect(FoodPartner.count).to eq 2
        expect(assigns(:inactive_food_partners).size).to be 2
      end

      it 'retrieves the food partners' do
        expect(assigns(:inactive_food_partners)).to include food_partner_1
        expect(assigns(:inactive_food_partners)).to include food_partner_2
      end

    end
  end

  describe '#new' do
    let(:make_request) { get :new }

    
    it_behaves_like 'requires admin authentication'
  end

  describe '#edit' do
    let!(:food_partner) { create(:food_partner) }
    let(:make_request) { get :edit, id: food_partner.id }

    
    it_behaves_like 'requires admin authentication'

    describe 'retrieving the food partner' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it 'retrieves the food partner' do
        expect(assigns[:food_partner]).to eq food_partner
      end

    end

  end

  describe '#create' do
    let(:make_request) { get :create, params }
    let(:params) do
      {
        food_partner: {
          company_name: 'Waterloo',
          cuisine: 'French',
          email: 'blah@blah.com',
          phone_number: '12345',
          contact_first_name: 'Will',
          contact_last_name: 'Young',
          image_file_name: 'image.jpg',
          minimum_spend: '10',
          minimum_attendees: '5',
          maximum_attendees: '100',
          delivery_cost: '50',
          delivery_text: 'free',
          availability_text: 'every day',
          url_slug: 'waterloo',
          lead_time_hours: '72',
          lowest_price_dish: '12',
        }
      }
    end

    it_behaves_like 'redirects when not authenticated'

    context 'creation of food partner' do
      let(:food_partner) { FoodPartner.all.first }
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it 'creates a food partner' do
        expect(FoodPartner.all.size).to be 1
      end

      it_behaves_like 'sets food partner properties'

      it 'sets the success message' do
        expect(flash[:success]).to eq 'Food Partner Created'
      end

      it 'redirects to the food partner path' do
        expect(response).to redirect_to edit_food_partner_path(food_partner)
      end

    end
  end

  describe '#destroy' do
    let(:food_partner) { create(:food_partner) }
    let(:make_request) { get :destroy, id: food_partner.id }

    it_behaves_like 'redirects when not authenticated'

    context 'destruction of food partner' do
      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
      end

      it 'destroys the Food Partner record' do
        expect(FoodPartner.all.size).to be 0
      end

      it 'redirects to the index page' do
        expect(response).to redirect_to food_partners_path
      end
    end
  end

  describe '#update' do
    let(:food_partner) { create(:food_partner) }
    let(:make_request) { get :update, params }
    let(:params) do
      {
        id: food_partner.id,
        food_partner: {
          company_name: 'Waterloo',
          cuisine: 'French',
          email: 'blah@blah.com',
          phone_number: '12345',
          contact_first_name: 'Will',
          contact_last_name: 'Young',
          image_file_name: 'image.jpg',
          minimum_spend: '10',
          minimum_attendees: '5',
          maximum_attendees: '100',
          delivery_cost: '50',
          delivery_text: 'free',
          availability_text: 'every day',
          url_slug: 'waterloo',
          lead_time_hours: '72',
          lowest_price_dish: '12',
        }
      }
    end

    it_behaves_like 'redirects when not authenticated'

    context 'update of food partner' do

      before do
        allow_any_instance_of(described_class)
          .to receive(:require_admin_authentication)
        request.env['HTTPS'] = 'on'
        make_request
        food_partner.reload
      end

      it_behaves_like 'sets food partner properties'

      it 'sets the success message' do
        expect(flash[:success]).to eq 'Food Partner updated'
      end

      it 'redirects to the food partner path' do
        expect(response).to redirect_to edit_food_partner_path(food_partner)
      end

    end

  end
end
