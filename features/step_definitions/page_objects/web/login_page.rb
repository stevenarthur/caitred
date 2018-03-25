module Web
  class LoginPage < BasePage
    def self.url
      '/login'
    end

    def click_reset_password_link
      @page.find('#js-reset-password').click
    end

    def submit
      @page.find('#js-login-submit').click
    end
  end
end
