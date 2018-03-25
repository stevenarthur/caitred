class Web::CaitredetteServiceRequestsController < WebsiteController

  def new
    @caitredette_req = CaitredetteServiceRequest.new
  end

  def create
    @caitredette_req = CaitredetteServiceRequest.new(permitted_params)
    if @caitredette_req.save
      process_request
    else
      render :new
    end
  end

private
  def permitted_params
    params.require(:caitredette_service_request).permit(:name,
                                                        :company_name,
                                                        :email,
                                                        :phone,
                                                        :postcode,
                                                        :preferred_communication_method,
                                                        :message)
  end

  def process_request
      TeamMailer.new_caitredette_service_notice(@caitredette_req).deliver_later
  end

end
