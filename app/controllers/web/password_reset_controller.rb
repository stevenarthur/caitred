module Web
  class PasswordResetController < WebsiteController
    def ssl_required
      !Rails.env.development? && !Rails.env.cucumber?
    end

    def new
    end

    def create
      customer = Customer.find_by_email params[:email]
      if customer.nil?
        flash[:error] = "Your email address could not be found in our system."
        redirect_to new_password_reset_path
      else 
        customer.assign_attributes(
          password_reset_token: SecureRandom.urlsafe_base64(30),
          reset_token_created: Time.now
        )
        customer.save(validate: false)
        send_email(customer)
      end
    end

    private

    def send_email(customer)
      CustomerMailer.reset_password(customer).deliver_later
    end
  end
end
