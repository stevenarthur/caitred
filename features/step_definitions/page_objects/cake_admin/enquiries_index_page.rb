module Admin
  class EnquiriesIndexPage < BasePage
    def self.url
      '/admin/enquiries'
    end

    def edit_first_enquiry
      @page.first('.js-enquiry-id').click
    end

    def enquiry_count
      @page.all('tr.js-enquiry').count
    end

    def create_enquiry
      @page.first('.create-button').click
    end

    def first_enquiry_with_status(status)
      EnquiryRow.new(@page.find(".js-enquiry[data-status='#{status}']"), @page)
    end

    def enquiries_awaiting_confirmation
      @page.all('#js-processing tr.js-enquiry')
    end

    def enquiries_awaiting_completion
      @page.all('#js-confirmed tr.js-enquiry')
    end
  end
end
