module Admin
  class StaticContentController < AdminController
    before_action :require_admin_authentication

    def admin_credits
    end
  end
end
