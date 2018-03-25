require 'rails_helper'

feature "Customer requests quote (new enquiry)" do

  it "enquiry is sent to team" do
    visit new_quote_path
    fill_in "Your Name", with: "Paul Millar"
    fill_in "Your Company Email", with: "paul@paulmillar.net"
    fill_in "Your Contact Number", with: "0425616397"
    select("Email", from: "How would you like to be contacted?")
    fill_in "Your Event's Postcode", with: 2017
    fill_in "What can we help you with?", with: "I would like to order some food please!"
    click_button "Submit"
    expect(page).to have_content "Thanks for 'chewsing' Caitre'd!"

    quote = Quote.last
    expect(quote.name).to eq "Paul Millar"
    expect(quote.email).to eq "paul@paulmillar.net"
    expect(quote.postcode).to eq 2017
    expect(quote.message).to eq "I would like to order some food please!"
  end

end
