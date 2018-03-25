require 'rails_helper'

describe EnquiryPrice do
  let(:food_partner){ FoodPartner.create(company_name: "Pips Fish & Chips", delivery_cost: 5.00) }
  let(:chip_item){ PackageableItem.create!(title: 'Chips', cost: 1.00, active: true, cost_to_youchews: 0.5,
                                           food_partner_id: food_partner.id, event_type: ["Lunch"]) }
  let(:fish_item){ PackageableItem.create!(title: 'Fish', cost: 2.50, active: true, cost_to_youchews: 2, 
                                           food_partner_id: food_partner.id, event_type: ["Lunch"]) }

  let(:enquiry) do
    enquiry = Enquiry.create!(food_partner: food_partner)
    enquiry.enquiry_items.new(packageable_item_id: chip_item.id, quantity: 20)
    enquiry.enquiry_items.new(packageable_item_id: fish_item.id, quantity: 10)
    enquiry
  end

  let(:enquiry_price){ EnquiryPrice.new(enquiry) }

  before :each do
    enquiry_price
  end

  describe "#food_cost" do
    it "returns food cost" do
      expect(enquiry_price.food_cost).to eq 45.00
    end
  end

  describe "#populate_price_from_cart" do
    it "populates prices from cart" do
      enquiry_price.populate_price_from_cart
      expect(enquiry.delivery_cost).to eq 5.0
      expect(enquiry.delivery_cost_to_us).to eq 5.0
      expect(enquiry.total_cost).to eq 50.0 # 45 from food_cost + # 5 from delivery_cost
    end

    # This is nested as its kinda dependent
    describe "#populate_total_price!" do
      it "populates the total price" do
        enquiry_price.populate_price_from_cart
        enquiry_price.populate_total_price!
        expect(enquiry.total_cost).to eq 50.00
        expect(enquiry.total_cost_to_us).to eq 35.00
      end
    end
  end

  describe "#payment_fee" do
    it "populates_the_payment_fee" do
      enquiry_price.populate_price_from_cart

      # Confirm Credit Card
      expect(enquiry.payment_method).to eq "Credit Card"

      expect(enquiry.total_cost).to eq 50.00
      expect(enquiry_price.payment_fee).to eq 1.75 #30 cents + 2.9%
    end
  end

  describe "#food_and_delivery_cost" do
    it "calculates food and delivery_cost" do
      enquiry_price.populate_price_from_cart
      expect(enquiry_price.food_and_delivery_cost).to eq 50.00
    end
  end

  # This is the food and delivery cost + payment fee 
  # (ie. Amount that is billed to the customer)
  describe "#amount_to_pay" do
    it "calculates amount to pay" do
      enquiry_price.populate_price_from_cart
      expect(enquiry_price.amount_to_pay).to eq 51.75
    end
  end

  describe '#record_amount_paid' do
    it "records_amount_paid" do
      enquiry_price.populate_price_from_cart
      enquiry_price.record_amount_paid!
      expect(enquiry.total_amount_paid).to eq 51.75
      expect(enquiry.payment_fee_paid).to eq 1.75
      expect(enquiry.paid).to eq true
    end
  end

  describe "#payment_method_includes_gst?" do
    pending "I dont actually know if a credit card should have GST included as yet"
  end

  describe "#gst_paid_to_supplier" do
    pending "I dont actually know if a credit card should have GST included as yet"
  end

end
