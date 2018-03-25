require 'rails_helper'

feature "Customer makes new order via shopping cart" do

  let(:customer){ create(:customer) }
  let(:food_partner){ create(:food_partner) }
  let(:packageable_item_1){ create(:food_item, cost: 10.00, cost_as_extra: 12.00, 
                                   active: true, event_type: ["Lunch", "Dinner"]) }
  let(:packageable_item_2){ create(:food_item, cost: 15.00, cost_as_extra: 15.00, 
                                   active: true, event_type: ["Dinner"]) }

  context "partner page" do
  end

  context "shopping cart" do
    pending 'item can be added'
    pending 'items calculated correctly'
    pending 'payment fee calculated correctly'
    pending 'can only add packageable items from a single partner' 
  end

  context "purchasing" do
    pending 'item is purchased'
  end

end
