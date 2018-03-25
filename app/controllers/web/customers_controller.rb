module Web
  class CustomersController < WebsiteController

    before_action :require_logged_in_customer, only: [:my_account, :edit]
    #before_action :right_customer, only: [:my_account, :edit]

    # rubocop:disable Metrics/AbcSize
    def create_account
      @customer = Customer.find params[:id]
      fail unless @customer.email == params[:customer][:email]
      @customer.update_attributes!(customer_params)
      @customer_session = Authentication::CustomerSession.new(
        email: @customer.email,
        password: customer_params[:password]
      )
      @customer_session.save!
    end
    # rubocop:enable Metrics/AbcSize

    def new
      redirect_to(root_path) if authenticated?
      @customer = Customer.new
    end

    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def create
      if authenticated?
        redirect_to(root_path)
        return
      end
      if customer_params[:password].blank?
        flash.now[:error] = 'Please enter a password.'
        @customer = Customer.new customer_params
        render :new
      elsif registered?
        flash.now[:error] = 'Email taken'
        @customer = Customer.new email: customer_params[:email]
        render :new
      else
        find_or_create_customer
        @customer.update_attributes!(customer_params)
        @current_customer_session = Authentication::CustomerSession.new(
          email: @customer.email,
          password: customer_params[:password]
        )
        @current_customer_session.save!
        send_email
        render :create_account
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    def reset_password
      @customer = Customer.find_by_password_reset_token(params[:token])
      validate_reset_token(false)
      return unless @customer.nil?

      render :reset_password_error
    end

    def do_reset_password
      @customer = Customer.find_by_password_reset_token(params[:token])
      validate_reset_token(true)
      if @customer.nil?
        render :reset_password_error
      else
        reset_customer_password
      end
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Passwords do not match, please try again.'
      render :reset_password
    end

    def my_account
      @enquiries = current_customer.enquiries
    end

    def edit
      @customer = current_customer
    end

    def update
      @customer = current_customer
      if @customer.update_attributes customer_params
        flash['success'] = 'Profile updated'
        redirect_to edit_customer_path
      else
        flash['error'] = 'We can update your profile'
        redirect_to 'edit'
      end
    end

    private

    def reset_customer_password
      @customer.assign_attributes(
          password_reset_token: nil,
          reset_token_created: nil,
          password: params[:password],
        )
      @customer.save(validate: false)
    end

    def validate_reset_token(delete_expired)
      return if @customer.nil?
      return if @customer.reset_token_created > (Time.now - 2.hours)
      if delete_expired
        @customer.assign_attributes(
          password_reset_token: nil,
          reset_token_created: nil
        )
        @customer.save(validate: false)
      end
      @customer = nil
    end

    def send_email
      CustomerMailer.new_registration(@customer).deliver_later
    end

    def registered?
      !Customer.registered.find_by_email(customer_params[:email]).nil?
    end

    def find_or_create_customer
      @customer =
        Customer.unregistered.find_by_email(customer_params[:email]) ||
        Customer.create!(customer_params)
    end

    def customer_params
      params_hash = params.require(:customer)
                    .permit(*Factories::CustomerFactory::ALLOWED_PARAMS)
      params_hash[:created_account] = true
      params_hash
    end
  end
end
