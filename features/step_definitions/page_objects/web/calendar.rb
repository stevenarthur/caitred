module Web
  class Calendar < BasePage
    def initialize(page)
      super(page)
      @element = page.find('.datepicker.dropdown-menu')
    end

    def visible?
      @element.visible?
    end
  end
end
