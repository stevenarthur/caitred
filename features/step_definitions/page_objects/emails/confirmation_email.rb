module Emails
  class ConfirmationEmail < BaseEmail
    def initialize(filename = 'tmp/emails/email3.txt')
      super
    end
  end
end
