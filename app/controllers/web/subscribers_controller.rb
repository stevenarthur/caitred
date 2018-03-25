module Web
  class SubscribersController < WebsiteController
    #layout 'website'

    def new
  		
    end

    def create
      begin
        Gibbon::API.new(ENV['MAILCHIMP_API']).lists.subscribe({:id => ENV['MAILCHIMP_LIST_ID'], 
                                                               :email => {:email => params[:email]}, 
                                                               :merge_vars => { :FNAME => params[:firstname], 
                                                                                :LNAME => params[:name] },
                                                               :double_optin => false})
        flash[:success] = 'Email address added'
        redirect_to success_subscriber_path
      rescue Gibbon::MailChimpError => e
        flash[:error] = e.message
      end
    end

    def destroy
  		
    end

    def success
      
    end

  end
end
