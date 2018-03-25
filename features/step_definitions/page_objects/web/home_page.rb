module Web
  class HomePage < BasePage
    def make_enquiry
      @page.click_link 'js-send-enquiry'
    end

    def view_faqs
      @page.click_link 'js-faqs'
    end

    def view_terms
      @page.click_link 'js-terms'
    end

    def view_privacy
      @page.click_link 'js-privacy'
    end

    def view_contact_us
      @page.click_link 'js-contact'
    end

    def view_about_us
      @page.click_link 'js-about'
    end

    def view_sell_with_us
      @page.click_link 'js-sell'
    end

    def view_team_lunch
      @page.click_link 'js-team-lunch'
    end

    def loaded?
      @page.find('body.home')
      true
    end
  end
end
