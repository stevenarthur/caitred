module Web
  class EnquiryConfirmationPage < BasePage
    def self.url_for_customer_email(email)
      customer = Customer.find_by_email(email)
      enquiry = customer.enquiries.where(status: EnquiryStatus::READY_TO_CONFIRM).first
      Rails.application.routes.url_helpers.ready_to_confirm_path(enquiry.confirmation_token)
    end

    def order_number?
      @page.find('#js-enquiry-id').text.length > 0
    end

    def event_date
      @page.find('#js-event-date').text
    end

    def event_time
      @page.find('#js-event-time').text
    end

    def attendees
      @page.find('#js-attendees').text
    end

    def menu_title
      @page.find('#js-menu-title').text
    end

    def customer_menu_content
      @page.find('#js-customer-menu-content').text
    end

    def confirm
      @page.execute_script(pin_override_script)
      @page.find('#js-confirm-button').click
    end

    private

    def pin_override_script
      <<-SCRIPT
        var Pin = Pin || function() {};
        Pin.Api = Pin.Api || function() {};
        Pin.Api.prototype.createCardToken = function()  {
          deferred = new $.Deferred();
          deferred.resolve({token: '123'});
          return deferred;
        }
      SCRIPT
    end
  end
end
