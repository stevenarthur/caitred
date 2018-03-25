module Web
  class RegisterPage < BasePage
    def self.url
      '/register'
    end

    def fill_password_confirmation(text)
      @page.fill_in 'js-password_confirmation', with: text
    end

    def submit
      @page.find('#js-register-submit').click
    end
  end
end
