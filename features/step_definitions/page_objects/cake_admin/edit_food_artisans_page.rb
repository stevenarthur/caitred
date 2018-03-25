module Admin
  class EditFoodPartnersPage < BasePage
    def self.url_for(name)
      food_partner = FoodPartner.find_by_company_name(name)
      "/admin/food_partners/#{food_partner.id}/edit"
    end

    def current_food_partner
      url = @page.driver.current_url
      food_partner_id = %r{food_partners\/(\d*)\/}.match(url).captures.first
      FoodPartner.find_by_id(food_partner_id)
    end

    def edit_menus
      @page.click_link 'Edit Menu Packages'
    end

    def fill_name(name)
      first_name, last_name = name.split(' ')
      fill_in 'js-contact-first-name', first_name
      fill_in 'js-contact-last-name', last_name
    end

    def fill_cuisine(cuisine)
      fill_in 'js-cuisine', cuisine
    end

    def fill_company(company)
      fill_in 'js-company-name', company
    end

    def fill_min_attendees(min)
      fill_in 'js-min-attendees', min
    end

    def fill_max_attendees(max)
      fill_in 'js-max-attendees', max
    end

    def submit
      @page.find('.js-judge-validate-food-partner').click
    end
  end
end
