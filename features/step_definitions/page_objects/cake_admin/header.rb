module Admin
  class Header < BasePage
    def logout
      @page.click_link 'js-logout'
    end

    def edit_my_profile
      @page.click_link 'js-edit-my-profile'
    end

    def reset_my_password
      @page.click_link 'js-reset-my-password'
    end

    def logged_in?
      !@page.find('.js-welcome').text.blank?
    end

    def welcoming_user
      @page.find('.js-current-user').text
    end

    def nav_visible?
      !@page.first('.navbar').nil?
    end
  end
end
