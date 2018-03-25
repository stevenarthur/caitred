module Admin
  class EditEnquiryPage < BasePage
    def save
      @page.click_button 'Save Enquiry'
    end

    def save_and_confirm_updated
      save
      @page.find '.alert'
    end

    def save_logistics
      @page.click_button 'Save Logistics'
    end

    def edit_logistics
      @page.click_link 'Edit Event Logistics'
    end

    def error_text
      @page.find('.js-errors').text
    end

    def choose_food_partners
      @page.click_link 'Select Potential Food Partners'
    end

    def not_been_sent?
      heading = @page.find('h4.js-supplier-enquiry')
      heading.text == 'This enquiry has not yet been sent to any Food Partners.'
    end

    def preview_supplier_email(company_name)
      @page.find(".js-preview[data-supplier='#{company_name}']").click
    end

    def successful_create?
      @page.find('.alert-success').text.include? 'Enquiry created'
    end

    def fill_event_type(type)
      @page.select type, from: 'js-event-type'
    end

    def fill_customer(name)
      loop do
        ready = @page.evaluate_script('Cake.EnquiryForm.loaded')
        break if ready
      end
      fill_in 'js-customer-field', name
      @page.find('.tt-dataset-customers').first('.tt-suggestion').click
    end

    def current_enquiry
      Enquiry.find(@page.driver.current_url.split('/')[-2].to_i)
    end

    def status_title
      @page.find('.js-status-title').text
    end

    def progress
      @page.find('.js-progress-enquiry').click
      loop do
        progressed = @page.evaluate_script('Cake.enquiryProgressed')
        break if progressed
      end
    end

    def regress
      @page.find('.js-regress-enquiry').click
      loop do
        progressed = @page.evaluate_script('Cake.enquiryProgressed')
        break if progressed
      end
    end

    def mark_spam
      @page.find('.js-mark-enquiry-spam').click
      loop do
        progressed = @page.evaluate_script('Cake.enquiryProgressed')
        break if progressed
      end
    end

    def mark_test
      @page.find('.js-mark-enquiry-test').click
      loop do
        progressed = @page.evaluate_script('Cake.enquiryProgressed')
        break if progressed
      end
    end

    def address_line_1
      @page.find('#js-address-line-1').text.gsub('Address: ', '')
    end

    def add_address
      @page.find('.js-add-address').click
      @page.find('#js-address-1')
    end

    def save_address
      @page.find('#js-save-address').click
      @page.find('#js-address-line-1')
    end
  end
end
