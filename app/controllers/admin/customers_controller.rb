module Admin
  class CustomersController < AdminController
    before_action :find_customer, only: [:edit, :update, :enquiries]
    before_action :require_admin_authentication

    def index
      @customers = Customer.all.order :first_name, :last_name, :company_name
    end

    def edit
    end

    def new
      @customer = Customer.new
    end

    def create
      @customer = Customer.new
      pw = (0...8).map { (65 + rand(26)).chr }.join
      params[:customer][:password] = pw
      params[:customer][:password_confirmation] = pw
      update_customer('created')
    end

    def enquiries
      @enquiries = @customer.enquiries
    end

    def update
      update_customer('updated')
    end

    private

    def update_customer(action_name)
      if @customer.update_attributes customer_params
        flash[:success] = "Customer #{action_name}"
        redirect_to edit_admin_customer_path(@customer)
      else
        flash[:error] = error_message
        render :edit, status: 400
      end
    end

    def error_message
      @customer.errors.messages.map do
        |key, value| "#{key} #{value.join(' and ')}"
      end.join(', ').capitalize + '.'
    end

    def find_customer
      @customer = Customer.find(params[:id] || params[:customer_id])
    end

    def customer_params
      params.require(:customer)
        .permit(*Factories::CustomerFactory::ALLOWED_PARAMS)
    end
  end
end
