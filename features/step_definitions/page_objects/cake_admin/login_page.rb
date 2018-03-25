module Admin
  class LoginPage < BasePage
    def login(username, password = 'password')
      @page.visit '/admin/login'
      fill_in 'User name', username
      fill_in 'Password', password
      @page.click_button 'Login'
    end

    def visible?
      !Header.new(@page).nav_visible?
    end
  end
end
