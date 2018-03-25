class EnquiryConfirmation
  attr_reader :enquiry

  def initialize(enquiry)
    @enquiry = enquiry
  end

  def self.find(token)
    enquiry = Enquiry.find_by_confirmation_token(token)
    return nil if enquiry.nil?
    EnquiryConfirmation.new(enquiry)
  end

  def self.regenerate(token)
    enquiry = Enquiry.find_by_confirmation_token(token)
    confirmation = EnquiryConfirmation.new(enquiry)
    confirmation.create_confirm_link(EnquiryStatus::READY_TO_CONFIRM)
    confirmation
  end

  def valid?
    @enquiry.confirmation_token_created > 10.days.ago
  end

  def confirm
    @enquiry.update_attributes!(
      status: EnquiryStatus::CONFIRMED,
      confirmation_token: nil,
      confirmation_token_created: nil
    )
  end

  def token
    @enquiry.confirmation_token
  end

  def ready_to_confirm?
    @enquiry.status == EnquiryStatus::READY_TO_CONFIRM &&
      !@enquiry.confirmation_token.nil?
  end

  def create_confirm_link(new_status)
    @enquiry.update_attributes!(
      status: new_status,
      confirmation_token: SecureRandom.urlsafe_base64(30),
      confirmation_token_created: Time.now
    )
  end
end
