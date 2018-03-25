module Admin
  class CustomerEnquiriesPage < BasePage
    def customer_name
      @page.find('.js-customer-name').text
    end

    def enquiry_count
      @page.all('.js-customer-enquiry').count
    end
  end
end
