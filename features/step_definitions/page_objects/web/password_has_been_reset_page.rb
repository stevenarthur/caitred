module Web
  class PasswordHasBeenResetPage < BasePage
    def loaded?
      @page.find('#js-thank-you').text ==
        'Thank you, please check your email for instructions on how to reset your password.'
    end
  end
end
