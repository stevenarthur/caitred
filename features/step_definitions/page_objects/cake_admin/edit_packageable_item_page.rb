module Admin
  class EditPackageableItemPage < BasePage
    def choose_type(type)
      id = "#js-type-#{type}"
      @page.find(id).set(true)
    end

    def choose_event_type(type)
      id = "#js-event-type-#{type}"
      @page.find(id).set(true)
    end

    def save
      @page.find('.js-save').click
    end
  end
end
