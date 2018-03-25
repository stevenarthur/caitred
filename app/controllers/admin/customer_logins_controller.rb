class Admin::CustomerLoginsController < AdminController
  before_action :require_admin_authentication

  def create
    customer = Customer.find(params[:id])
    if Authentication::CustomerSession.create(customer)
      flash[:notice] = "Sign in as #{customer.first_name} successful"
      redirect_to partner_search_path
    else
      redirect_to admin_customers_path, notice: 'Login as user failed'
    end
  end

end

