module Emails
  class SupplierEnquiryEmail < BaseEmail
    def initialize(filename = 'tmp/emails/email2.txt')
      super
    end
  end
end
