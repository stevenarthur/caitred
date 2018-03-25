require 'rails_helper'

describe EnquiryStatus do
  let(:enquiry) do
    double(
      Enquiry,
      :status= => nil,
      :status => status,
      :create_confirm_link => nil
    )
  end

  describe '#progress' do

    describe 'invalid progressions' do

      context 'enquiry status is not in the workflow' do
        let(:status) { EnquiryStatus::TEST }

        it 'throws an exception' do
          expect { EnquiryStatus.progress(enquiry) }.to raise_error("Enquiry cannot be progressed through workflow")
        end
      end

      context 'enquiry status is completed' do
        let(:status) { EnquiryStatus::COMPLETED }

        it 'throws an exception if the enquiry is not already completed' do
          expect { EnquiryStatus.progress(enquiry) }.to raise_error("Enquiry cannot be progressed through workflow")
        end
      end
    end

    describe 'valid progressions' do
      before do
        EnquiryStatus.progress(enquiry)
      end

      context 'new' do
        let(:status) { EnquiryStatus::NEW }

        it 'moves to Processing' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::PROCESSING)
        end
      end

      context 'processing' do
        let(:status) { EnquiryStatus::PROCESSING }

        it 'moves to Waiting on Supplier' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::WAITING_ON_SUPPLIER)
        end
      end

      context 'Waiting on Supplier' do
        let(:status) { EnquiryStatus::WAITING_ON_SUPPLIER }

        it 'moves to Ready to Confirm' do
          expect(enquiry).to have_received(:create_confirm_link)
            .with(EnquiryStatus::READY_TO_CONFIRM)
        end
      end

      context 'Ready to confirm' do
        let(:status) { EnquiryStatus::READY_TO_CONFIRM }

        it 'moves to Confirmed' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::CONFIRMED)
        end
      end

      context 'Confirmed' do
        let(:status) { EnquiryStatus::CONFIRMED }

        it 'moves to Delivered' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::DELIVERED)
        end
      end

      context 'Delivered' do
        let(:status) { EnquiryStatus::DELIVERED }

        it 'moves to Completed' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::COMPLETED)
        end
      end
    end
  end

  describe '#regress' do
    describe 'invalid regressions' do

      context 'enquiry status is not in the workflow' do
        let(:status) { EnquiryStatus::TEST }

        it 'throws an exception' do
          expect { EnquiryStatus.regress(enquiry) }.to raise_error("Enquiry cannot be regressed through workflow")
        end
      end

      context 'enquiry status is new' do
        let(:status) { EnquiryStatus::NEW }

        it 'throws an exception if the enquiry is not already completed' do
          expect { EnquiryStatus.regress(enquiry) }.to raise_error("Enquiry cannot be regressed through workflow")
        end
      end
    end

    describe 'valid progressions' do
      before do
        EnquiryStatus.regress(enquiry)
      end

      context 'processing' do
        let(:status) { EnquiryStatus::PROCESSING }

        it 'moves to New' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::NEW)
        end
      end

      context 'Waiting on Supplier' do
        let(:status) { EnquiryStatus::WAITING_ON_SUPPLIER }

        it 'moves to Processing' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::PROCESSING)
        end
      end

      context 'Ready to confirm' do
        let(:status) { EnquiryStatus::READY_TO_CONFIRM }

        it 'moves to Waiting on supplier' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::WAITING_ON_SUPPLIER)
        end
      end

      context 'Confirmed' do
        let(:status) { EnquiryStatus::CONFIRMED }

        it 'moves to Delivered' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::READY_TO_CONFIRM)
        end
      end

      context 'Delivered' do
        let(:status) { EnquiryStatus::DELIVERED }

        it 'moves to Completed' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::CONFIRMED)
        end
      end

      context 'Completed' do
        let(:status) { EnquiryStatus::COMPLETED }

        it 'moves to Completed' do
          expect(enquiry).to have_received(:status=)
            .with(EnquiryStatus::DELIVERED)
        end
      end
    end
  end

  describe '#next_status' do
    it 'gets the next status for New' do
      expect(EnquiryStatus.next_status(EnquiryStatus::NEW).to_s)
        .to eq EnquiryStatus::PROCESSING
    end
  end

  describe '#last_status' do
    it 'gets the previous status for PROCESSING' do
      expect(EnquiryStatus.last_status(EnquiryStatus::PROCESSING).to_s)
        .to eq EnquiryStatus::NEW
    end
  end

  describe '#can_progress?' do
    it 'gets true for Processing' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::PROCESSING))
        .to be true
    end

    it 'gets true for Waiting on Supplier' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be true
    end

    it 'gets true for Ready to Confirm' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::READY_TO_CONFIRM))
        .to be true
    end

    it 'gets true for Confirmed' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::CONFIRMED))
        .to be true
    end

    it 'gets true for Delivered' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::DELIVERED))
        .to be true
    end

    it 'gets false for anything else' do
      expect(EnquiryStatus.can_progress?(EnquiryStatus::COMPLETED))
        .to be false
    end
  end

  describe '#can_regress?' do
    it 'gets true for Processing' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::PROCESSING))
        .to be true
    end

    it 'gets true for Waiting on Supplier' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be true
    end

    it 'gets true for Ready to Confirm' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::READY_TO_CONFIRM))
        .to be true
    end

    it 'gets true for Confirmed' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::CONFIRMED))
        .to be true
    end

    it 'gets true for Delivered' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::DELIVERED))
        .to be true
    end

    it 'gets true for COMPLETED' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::COMPLETED))
        .to be true
    end

    it 'gets false for anything else' do
      expect(EnquiryStatus.can_regress?(EnquiryStatus::NEW))
        .to be false
    end
  end

  describe '#can_cancel?' do
    it 'gets true for Processing' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::PROCESSING))
        .to be true
    end

    it 'gets true for Waiting on Supplier' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be true
    end

    it 'gets true for Ready to Confirm' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::READY_TO_CONFIRM))
        .to be true
    end

    it 'gets true for Confirmed' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::CONFIRMED))
        .to be true
    end

    it 'gets false for Delivered' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::DELIVERED))
        .to be false
    end

    it 'gets false for anything else' do
      expect(EnquiryStatus.can_cancel?(EnquiryStatus::COMPLETED))
        .to be false
    end
  end

  describe '#can_mark as spam or test?' do
    it 'gets true for Processing' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::PROCESSING))
        .to be true
    end

    it 'gets false for Waiting on Supplier' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be false
    end

    it 'gets false for Ready to Confirm' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::READY_TO_CONFIRM))
        .to be false
    end

    it 'gets false for Confirmed' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::CONFIRMED))
        .to be false
    end

    it 'gets false for Delivered' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::DELIVERED))
        .to be false
    end

    it 'gets false for anything else' do
      expect(EnquiryStatus.can_mark_test_or_spam?(EnquiryStatus::COMPLETED))
        .to be false
    end
  end

  describe '#value_of' do
    it 'gets 1 for New' do
      expect(EnquiryStatus.value_of(EnquiryStatus::NEW))
        .to be 1
    end

    it 'gets 2 for Processing' do
      expect(EnquiryStatus.value_of(EnquiryStatus::PROCESSING))
        .to be 2
    end

    it 'gets 3 for Waiting on Supplier' do
      expect(EnquiryStatus.value_of(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be 3
    end

    it 'gets 4 for Ready to Confirm' do
      expect(EnquiryStatus.value_of(EnquiryStatus::READY_TO_CONFIRM))
        .to be 4
    end

    it 'gets 5 for Confirmed' do
      expect(EnquiryStatus.value_of(EnquiryStatus::CONFIRMED))
        .to be 5
    end

    it 'gets 6 for Delivered' do
      expect(EnquiryStatus.value_of(EnquiryStatus::DELIVERED))
        .to be 6
    end

    it 'gets 7 for Completed' do
      expect(EnquiryStatus.value_of(EnquiryStatus::COMPLETED))
        .to be 7
    end

    it 'gets 100 for Cancelled' do
      expect(EnquiryStatus.value_of(EnquiryStatus::CANCELLED))
        .to be 100
    end

    it 'gets 101 for Spam' do
      expect(EnquiryStatus.value_of(EnquiryStatus::SPAM))
        .to be 101
    end

    it 'gets 102 for Test' do
      expect(EnquiryStatus.value_of(EnquiryStatus::TEST))
        .to be 102
    end
  end

  describe '#post_confirmation?' do
    it 'gets true for Processing' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::PROCESSING))
        .to be false
    end

    it 'gets false for Waiting on Supplier' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::WAITING_ON_SUPPLIER))
        .to be false
    end

    it 'gets false for Ready to Confirm' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::READY_TO_CONFIRM))
        .to be false
    end

    it 'gets false for Confirmed' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::CONFIRMED))
        .to be true
    end

    it 'gets false for Delivered' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::DELIVERED))
        .to be true
    end

    it 'gets false for anything else' do
      expect(EnquiryStatus.post_confirmation?(EnquiryStatus::COMPLETED))
        .to be true
    end
  end
end
