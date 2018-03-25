module Admin
  class EditAdminUserPage < BasePage
    def fill_name(first_name, last_name)
      fill_in 'js-first-name', first_name
      fill_in 'js-last-name', last_name
    end

    def fill_username(username)
      fill_in 'js-username', username
    end

    def fill_email(email)
      fill_in 'js-email', email
    end

    def fill_mobile(mobile)
      fill_in 'js-mobile-number', mobile
    end

    def fill_password(password)
      fill_in 'js-password', password
      fill_in 'js-password_confirmation', password
    end

    def make_power_user
      @page.find('#js-power-user').set(true)
    end

    def save
      @page.click_button 'Save Admin User'
    end

    def wait_for_updated_message
      @page.find('.alert')
    end
  end
end
