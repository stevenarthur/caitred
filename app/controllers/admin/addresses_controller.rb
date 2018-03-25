module Admin
  class AddressesController < AdminController
    before_action :require_admin_authentication
    before_action :find_customer
    before_action :find_address, only: [:show, :update, :edit, :set_default]

    def new
      @address = Address.new(customer: @customer)
    end

    def create
      @address = Address.create! address_params
      respond_to do |format|
        format.json { render }
        format.html { redirect_to edit_admin_customer_address_path(@customer, @address) }
      end
    end

    def edit
    end

    def update
      @address.update_attributes! address_params
      head 204
    end

    def show
    end

    def set_default
      @customer.default_address = (@address)
      head 204
    end

    private

    def find_customer
      @customer = Customer.find params[:customer_id]
    end

    def find_address
      @address = Address.find(params[:id] || params[:address_id])
      fail if @address.customer != @customer
    end

    def address_params
      address_properties = params.require(:address).permit(
        :company,
        :line_1,
        :line_2,
        :suburb,
        :postcode,
        :parking_information
      )
      address_properties[:customer_id] = @customer.id
      address_properties
    end
  end
end
