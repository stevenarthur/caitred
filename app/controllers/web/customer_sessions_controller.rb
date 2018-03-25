module Web
  class CustomerSessionsController < WebsiteController
    def ssl_required
      !Rails.env.development? && !Rails.env.cucumber?
    end

    def new
      redirect_to(root_path) if authenticated?
      @customer_session = Authentication::CustomerSession.new
    end

    def create
      customer_params = customer_session_params(params)
      @customer_session = Authentication::CustomerSession.new customer_params
      @customer_session.remember_me = remember_me
      begin
        @customer_session.save!
        redirect_to root_path
      rescue
        flash.now[:error] = 'Login failed'
        redirect_to customer_login_path
      end
    end

    def destroy
      current_customer_session.destroy unless current_customer_session.nil?
      redirect_to :back
    rescue ActionController::RedirectBackError
      redirect_to root_path
    end

    private

    def remember_me
      params[:authentication_customer_session][:remember_me] == '1'
    end

    def customer_session_params(params)
      params.require(:authentication_customer_session).permit(:email, :password)
    end
  end
end
