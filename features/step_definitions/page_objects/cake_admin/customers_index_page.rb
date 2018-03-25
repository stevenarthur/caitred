module Admin
  class CustomersIndexPage < BasePage
    def self.url
      '/admin/customers'
    end

    def customer_count
      @page.all('.js-customer').size
    end

    def add_enquiry_for(name)
      @page.find(".js-create-enquiry[data-name='#{name}']").click
    end

    def customer_names
      @page.all('.js-customer-name').map(&:text)
    end

    def enquiry_count_for(name)
      view_enquiries_button(name).text.to_i
    end

    def view_enquiries_for(name)
      view_enquiries_button(name).click
    end

    private

    def view_enquiries_button(name)
      @page.find(".js-customer-enquiries[data-name='#{name}']")
    end
  end
end
