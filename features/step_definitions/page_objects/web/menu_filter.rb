module Web
  class MenuFilter < BasePage
    def initialize(page, filter_name)
      @page = page
      @element = page.find(".js-menu-tag[data-name='#{filter_name}']")
    end

    def disabled?
      @element[:class].include? 'disabled'
    end
  end
end
