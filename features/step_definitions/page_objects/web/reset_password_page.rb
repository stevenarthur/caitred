module Web
  class ResetPasswordPage < BasePage
    def submit
      @page.find('#js-reset-password-submit').click
    end
  end
end
