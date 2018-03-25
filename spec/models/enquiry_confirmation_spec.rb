require 'rails_helper'

describe EnquiryConfirmation do
  let(:token) { SecureRandom.urlsafe_base64 }
  before do
    allow(Enquiry).to receive(:find_by_confirmation_token)
      .and_return enquiry
  end

  describe '#find' do
    let(:enquiry) { create(:enquiry) }
    before do
      allow(EnquiryConfirmation).to receive(:new)
    end

    it 'creates a new enquiry confirmation with the matching token' do
      EnquiryConfirmation.find('some token')
      expect(EnquiryConfirmation).to have_received(:new)
        .with(enquiry)
    end
  end

  describe '#valid?' do
    let(:enquiry) do
      create(
        :enquiry,
        confirmation_token: token,
        confirmation_token_created: created_date
      )
    end
    let(:enquiry_confirmation) { EnquiryConfirmation.new(enquiry) }

    context 'token expired' do
      let(:created_date) { 15.days.ago }

      it 'returns false' do
        expect(enquiry_confirmation.valid?).to eq false
      end
    end

    context 'token not expired' do
      let(:created_date) { 2.hours.ago }

      it 'returns true' do
        expect(enquiry_confirmation.valid?).to eq true
      end
    end
  end

  describe '#regenerate' do
    let(:enquiry) do
      enquiry = create(:enquiry)
      allow(enquiry).to receive(:update_attributes!)
      enquiry
    end

    before do
      EnquiryConfirmation.regenerate(enquiry)
    end

    it 'calls create_confirm_link for the enquiry' do
      expect(enquiry).to have_received(:update_attributes!)
    end

  end
end
