module Web
  class NewSupplierController < WebsiteController

    def new_supplier_enquiry
      if all_params_present?
        ProcessNewSupplierEnquiryJob.perform_later(request.ip, request.user_agent, 
                                                   supplier_enquiry_params)
        redirect_to sell_with_us_thanks_path
      else
        flash[:error] = "There was a problem submitting your request" 
        render 'web/static_content/sell_with_us'
      end
    end

    def thanks
    end

    private

    def supplier_enquiry_params
      params.permit(:name, :email, :phone, :company_name, :more_info, :website, :delivery)
    end

    def all_params_present?
      params.has_key?(:name) && 
        params.has_key?(:email) && 
          params.has_key?(:phone) && 
            params.has_key?(:company_name) && 
              params.has_key?(:more_info) && 
                params.has_key?(:website) && 
                    params.has_key?(:delivery)
    end

  end

end
