require 'rails_helper'

describe SupplierCommunication do

  context 'confirmation email from supplier' do
    let(:enquiry) do
      create(
        :enquiry,
        status: EnquiryStatus::WAITING_ON_SUPPLIER
      )
    end

    context 'email begins with yes' do
      let(:comm) do
        create(
          :supplier_communication,
          enquiry: enquiry,
          email_text: email_text
        )
      end
      before do
        comm.update_enquiry!
      end

      context 'upper case' do
        let(:email_text) { 'YES I will do it' }

        it 'moves the enquiry to ready to confirm' do
          expect(enquiry.status).to eq EnquiryStatus::READY_TO_CONFIRM
        end
      end

      context 'lower case' do
        let(:email_text) { 'yes ok' }

        it 'moves the enquiry to ready to confirm' do
          expect(enquiry.status).to eq EnquiryStatus::READY_TO_CONFIRM
        end
      end

      context 'enquiry is not waiting for supplier' do
        let(:email_text) { 'yes ok' }
        let(:enquiry) do
          create(
            :enquiry,
            status: EnquiryStatus::NEW
          )
        end

        it 'does not change the status' do
          expect(enquiry.status).to eq EnquiryStatus::NEW
        end
      end
    end

    context 'email does not begin with yes' do
      let(:email_text) { 'I do not know' }

      it 'leaves the enquiry status alone' do
        expect(enquiry.status).to eq EnquiryStatus::WAITING_ON_SUPPLIER
      end
    end
  end

end
