module Web
  class WelcomeBox < BasePage
    def click_login_link
      @page.find('#js-login').click
    end

    def click_logout_link
      @page.find('#js-logout').click
    end

    def click_register_link
      @page.find('#js-register').click
    end

    def message
      @page.find('.js-welcome-message').text
    end
  end
end
