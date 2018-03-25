module Admin
  class FoodPartnersIndexPage < BasePage
    def self.url
      '/admin/food_partners'
    end

    def edit(name)
      @page.find(".js-edit-partner[data-name='#{name}']").click
    end

    def add
      @page.click_link 'Add Food Partner'
    end

    def number_of_partners
      @page.all('.js-food-partner').size
    end

    def all_company_names
      @page.all('.js-partner-company-name').map(&:text)
    end
  end
end
