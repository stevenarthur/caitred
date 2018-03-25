module Admin
  class ResetPasswordPage < BasePage
    def fill_password(password)
      fill_in 'js-password', password
      fill_in 'js-password_confirmation', password
    end

    def submit
      @page.click_button 'Update Password'
    end
  end
end
