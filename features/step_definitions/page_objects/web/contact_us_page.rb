require_relative 'content_page'

module Web
  class ContactUsPage < ContentPage
    def self.url
      '/contact_us'
    end

    def click_enquiry_link
      @page.find('#js-enquiry').click
    end
  end
end
