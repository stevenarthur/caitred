module Admin
  class AdminUsersIndexPage < BasePage
    def self.url
      '/admin/users'
    end

    def visible?
      @page.find('h2', text: 'Users')
    rescue
      false
    end

    def add_user
      @page.click_link 'Add User'
    end

    def delete_user(name)
      @page.find(".js-delete-user[data-name='#{name}']").click
    end

    def user_count
      @page.all('.js-user').size
    end

    def edit_user(name)
      @page.find(".js-edit-user[data-name='#{name}']").click
    end

    def reset_password(name)
      @page.find(".js-reset-password[data-name='#{name}']").click
    end

    def users_actual_names
      @page.all('.js-user-actual-name').map(&:text)
    end
  end
end
