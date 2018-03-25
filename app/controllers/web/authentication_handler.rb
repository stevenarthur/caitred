module Web
  module AuthenticationHandler
    def current_customer_session
      return @current_customer_session if defined?(@current_customer_session)
      @current_customer_session = Authentication::CustomerSession.find
    end

    def current_customer
      return nil if current_customer_session.nil?
      current_customer_session.customer
    end

    def authenticated?
      !current_customer.nil?
    end

    def require_logged_in_customer
      redirect_to customer_login_path unless authenticated?
    end

    def user_identifier
      (current_customer.nil?) ? session.id : current_customer.email
    end
  end
end
