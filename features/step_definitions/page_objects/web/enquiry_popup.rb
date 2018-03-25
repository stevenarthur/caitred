module Web
  class EnquiryPopup < BasePage
    def visible?
      modal = @page.find('#js-enquiry-modal')
      modal.find('.js-main-content')
    end
  end
end
