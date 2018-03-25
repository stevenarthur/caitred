module Web
  class MenuPanel < BasePage
    def initialize(args)
      super
      @element = @page.find('#js-menu-panel')
    end

    def heading
      @element.text
    end
  end
end
