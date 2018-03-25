require 'rails_helper'

describe Web::QuotesController do
  let(:food_partner){ FoodPartner.create( company_name: 'my company', minimum_spend: 0, minimum_attendees: 0, 
                                          maximum_attendees: 0, delivery_cost: 0 )}
  let(:valid_params) do
    { name: 'Paul Millar', email: 'paul@digitaldawn.com.au', date: '20th Jan 2015', postcode: '2017',
      contact_method: 'email', company: 'Digital Dawn', number_of_people: 20, phone: '0425616397', message: 'this is my message',
      food_partner_id: food_partner.id }
  end

  describe "POST #create" do

    it "creates the quote" do
      expect {
        post :create, quote: valid_params
      }.to change(Quote, :count).by 1
    end

    it "creates the quote without a food partner" do
      valid_params[:food_partner_id] = nil
      expect {
        post :create, quote: valid_params
      }.to change(Quote, :count).by 1
    end
    
    
  end
end
