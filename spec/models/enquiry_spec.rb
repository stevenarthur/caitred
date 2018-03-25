require 'rails_helper'

describe Enquiry do

  describe "#partner_reminder_due?" do
    it "isn't due if already sent" do
      e = Enquiry.new(partner_reminder_sent: true)
      expect(e.partner_reminder_due?).to eq false
    end
    it "isn't due if in less than 12 hours time" do
      e = Enquiry.new(partner_reminder_sent: false, 
                      event_time: Time.current + 13.hours,
                      event_date: Date.current + 24.hours)
      expect(e.partner_reminder_due?).to eq false
    end
    it "is due if in less than 12 hours time" do
      e = Enquiry.new(partner_reminder_sent: false, 
                      event_time: Time.current + 10.hours,
                      event_date: Date.current)
      expect(e.partner_reminder_due?).to eq true
    end
  end


  describe "#partner_reminder_due?" do
    it "isn't due if already sent" do
      e = Enquiry.new(feedback_email_sent: true)
      expect(e.feedback_email_due?).to eq false
    end

    it "isn't due if event was under 24 hours ago" do
      e = Enquiry.new(feedback_email_sent: false, 
                      event_time: Time.current - 1.hours,
                      event_date: Time.current)
      expect(e.feedback_email_due?).to eq false
    end
    it "is due if event was over 24 hours ago" do
      e = Enquiry.new(feedback_email_sent: false, 
                      event_time: Time.current - 2.hours,
                      event_date: (Time.current - 24.hours))
      expect(e.feedback_email_due?).to eq true
    end
  end

  describe '#next_status' do
    before do
      allow(EnquiryStatus).to receive(:next_status)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.next_status
      expect(EnquiryStatus).to have_received(:next_status)
        .with(EnquiryStatus::NEW)
    end
  end

  describe '#last_status' do
    before do
      allow(EnquiryStatus).to receive(:last_status)
    end

    it 'gets the last status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'Processing')
      enquiry.last_status
      expect(EnquiryStatus).to have_received(:last_status)
        .with(EnquiryStatus::PROCESSING)
    end
  end

  describe '#can_progress' do
    before do
      allow(EnquiryStatus).to receive(:can_progress?)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.can_progress?
      expect(EnquiryStatus).to have_received(:can_progress?)
        .with(EnquiryStatus::NEW)
    end
  end

  describe '#post_confirmation?' do
    before do
      allow(EnquiryStatus).to receive(:post_confirmation?)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.post_confirmation?
      expect(EnquiryStatus).to have_received(:post_confirmation?)
        .with(EnquiryStatus::NEW)
    end
  end

  describe '#status_value' do
    before do
      allow(EnquiryStatus).to receive(:value_of)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.status_value
      expect(EnquiryStatus).to have_received(:value_of)
        .with(EnquiryStatus::NEW)
    end
  end

  describe '#can_regress' do
    before do
      allow(EnquiryStatus).to receive(:can_regress?)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'Processing')
      enquiry.can_regress?
      expect(EnquiryStatus).to have_received(:can_regress?)
        .with(EnquiryStatus::PROCESSING)
    end
  end

  describe '#can_cancel?' do
    before do
      allow(EnquiryStatus).to receive(:can_cancel?)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.can_cancel?
      expect(EnquiryStatus).to have_received(:can_cancel?)
        .with(EnquiryStatus::NEW)
    end
  end

  describe '#can_mark_test_or_spam?' do
    before do
      allow(EnquiryStatus).to receive(:can_mark_test_or_spam?)
    end

    it 'gets the next status from EnquiryStatus' do
      enquiry = Enquiry.new(status: 'New')
      enquiry.can_mark_test_or_spam?
      expect(EnquiryStatus).to have_received(:can_mark_test_or_spam?)
        .with(EnquiryStatus::NEW)
    end
  end

  describe 'scopes' do
    let!(:new_enquiry) { create(:enquiry, status: EnquiryStatus::NEW) }
    let!(:processing_enquiry) { create(:enquiry, status: EnquiryStatus::PROCESSING) }
    let!(:supplier_enquiry) { create(:enquiry, status: EnquiryStatus::WAITING_ON_SUPPLIER) }
    let!(:ready_enquiry) { create(:enquiry, status: EnquiryStatus::READY_TO_CONFIRM) }
    let!(:confirmed_enquiry) { create(:enquiry, status: EnquiryStatus::CONFIRMED) }
    let!(:delivered_enquiry) { create(:enquiry, status: EnquiryStatus::DELIVERED) }
    let!(:completed_enquiry) { create(:enquiry, status: EnquiryStatus::COMPLETED) }
    let!(:spam_enquiry) { create(:enquiry, status: EnquiryStatus::SPAM) }
    let!(:cancelled_enquiry) { create(:enquiry, status: EnquiryStatus::CANCELLED) }
    let!(:test_enquiry) { create(:enquiry, status: EnquiryStatus::TEST) }

    describe '#completed' do
      let(:enquiries) { Enquiry.completed }

      it 'returns the correct number of enquiries' do
        expect(enquiries.size).to be 1
      end

      it 'includes the new enquiry' do
        expect(enquiries).to include completed_enquiry
      end
    end

    describe '#awaiting_confirmation' do
      let(:enquiries) { Enquiry.awaiting_confirmation }

      it 'returns the correct number of enquiries' do
        expect(enquiries.size).to be 4
      end

      it 'includes the new enquiry' do
        expect(enquiries).to include new_enquiry
      end

      it 'includes the processing enquiry' do
        expect(enquiries).to include processing_enquiry
      end

      it 'includes the waiting on supplier enquiry' do
        expect(enquiries).to include supplier_enquiry
      end

      it 'includes the ready to confirm enquiry' do
        expect(enquiries).to include ready_enquiry
      end
    end

    describe '#awaiting_completion' do
      let(:enquiries) { Enquiry.awaiting_completion }

      it 'returns the correct number of enquiries' do
        expect(enquiries.size).to be 2
      end

      it 'includes the confirmed enquiry' do
        expect(enquiries).to include confirmed_enquiry
      end

      it 'includes the delivered enquiry' do
        expect(enquiries).to include delivered_enquiry
      end
    end
  end

  describe 'setting default address' do
    let(:customer) { create(:customer) }

    context 'customer has no addresses' do
      it 'does not fail' do
        Enquiry.new(customer: customer).save!
      end
    end

    context 'customer has an address' do
      let(:enquiry)  do
        enquiry = Enquiry.new(customer: customer)
        enquiry.save!
        enquiry
      end
      let(:address)  { create(:address) }
      before do
        allow(customer).to receive(:default_address)
          .and_return address
      end

      it 'sets the address as the selected address for the enquiry' do
        expect(enquiry.address).to eq address
      end
    end

    context 'enquiry has an address' do
      let(:enquiry) do
        enquiry = Enquiry.new(customer: customer, address: enquiry_address)
        enquiry.save!
        enquiry
      end
      let(:enquiry_address)  { create(:address) }
      let(:other_address)  { create(:address) }
      before do
        allow(customer).to receive(:default_address)
          .and_return other_address
      end

      it 'does not overwrite the address' do
        expect(enquiry.address).to eq enquiry_address
      end
    end
  end

  describe '#create_confirm_link' do
    let(:enquiry) { create(:enquiry) }

    before do
      enquiry.create_confirm_link(EnquiryStatus::READY_TO_CONFIRM)
    end

    it 'updates the status' do
      expect(enquiry.status).to eq EnquiryStatus::READY_TO_CONFIRM
    end

    it 'stores a token and expiry date' do
      expect(enquiry.confirmation_token).not_to be_nil
      expect(enquiry.confirmation_token_created).not_to be_nil
    end
  end

  describe '#ready_to_confirm?' do
    let(:token) { SecureRandom.urlsafe_base64 }
    let(:enquiry) { create(:enquiry, status: status, confirmation_token: token) }

    context 'status is ready to confirm' do
      let(:status) { EnquiryStatus::READY_TO_CONFIRM }

      it 'is true' do
        expect(enquiry).to be_ready_to_confirm
      end
    end

    context 'any other status' do
      let(:status) { EnquiryStatus::NEW }

      it 'is false' do
        expect(enquiry).not_to be_ready_to_confirm
      end
    end
  end

  describe 'customer_menu_html' do
    let(:customer_menu_content) do
      <<-CONTENT
Line 1
Line 2
      CONTENT
    end
    let(:enquiry) { create(:enquiry, customer_menu_content: customer_menu_content) }

    it 'substitutes newlines for <br>' do
      expect(enquiry.customer_menu_html).to eq 'Line 1<br>Line 2<br>'
    end
  end

  describe 'recording status changes' do
    let(:enquiry) { create(:enquiry) }

    context 'status changed' do
      before do
        enquiry.update_attributes! status: EnquiryStatus::PROCESSING
        enquiry.reload
      end

      it 'records a status audit record' do
        expect(enquiry.status_audits.size).to eq 2
      end
    end

    context 'other attributes changed' do
      before do
        enquiry.update_attributes! source: 'Google'
        enquiry.reload
      end

      it 'records a status audit record' do
        expect(enquiry.status_audits.size).to eq 1
      end
    end
  end

  describe '#confirmed_date' do
    let(:enquiry) { create(:enquiry) }

    context 'enquiry is completed' do
      before do
        enquiry.update_attributes! status: EnquiryStatus::COMPLETED
      end

      it 'is not nil' do
        expect(enquiry.confirmed_date).not_to be_nil
      end
    end

    context 'enquiry is not completed' do
      it 'is nil' do
        expect(enquiry.confirmed_date).to be_nil
      end
    end
  end

end
