module Admin
  module AuthenticationHandler
    def require_admin_authentication
      redirect_to login_path unless authenticated?
      current_user
    end

    def require_power_user
      return false if require_admin_authentication.nil?
      return true if power_user?
      render template: 'shared/forbidden', status: 403
      false
    end

    def authenticated?
      !current_user.nil?
    end

    def power_user?
      authenticated? && current_user.is_power_user
    end

    private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = Authentication::AdminUserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
  end
end
