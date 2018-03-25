module Web
  class OmniauthCallbacksController < WebsiteController
    #before_filter :load_authlogic

    def linkedin
      auth = request.env["omniauth.auth"]
      #raise auth.inspect
      if  customer = Customer.find_by_email(auth['info']['email'])
        customer.create_session

        #current_user.authentications.find_or_create_by_provider_and_uid(auth['provider'], auth['uid'])
      else
        customer = Customer.create_with_linkedin(auth)
        CustomerMailer.new_registration(customer).deliver_later
        customer.create_session
      end
      flash[:notice] = "Authentication successful."
      redirect_to my_account_path
    end

  end
end
