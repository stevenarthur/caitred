module Web
  class SupplierEnquiryForm < BasePage
    def self.url
      '/sell_with_us'
    end

    def submit
      @page.find('.js-submit').click
    end
  end
end
