describe OldEnquiryRecord do
  let!(:enquiry_1) { OldEnquiryRecord.create! enquiry_id: 1 }
  let!(:enquiry_2) { OldEnquiryRecord.create! enquiry_id: 1 }
  let!(:enquiry_3) { OldEnquiryRecord.create! enquiry_id: 2 }

  describe 'scope by_enquiry' do
    it 'retrieves the correct enquiries' do
      enquiries = OldEnquiryRecord.by_enquiry 1
      expect(enquiries).to match_array [enquiry_1, enquiry_2]
    end
  end
end
