module Web
  class MenuDialog < BasePage
    def initialize(page)
      super(page)
      @element = page.find('#js-enquiry-modal .modal-content')
    end

    def visible?
      @element.visible?
    end
  end
end
