module Admin
  class EnquiriesController < AdminController
    before_action :find_enquiry, except: [:index, :new, :create, :new_for_customer]
    before_action :require_admin_authentication

    def new
      @enquiry = Enquiry.new customer: Customer.new
    end

    def index
      @processing_enquiries = Enquiry.awaiting_confirmation.order 'created_at DESC'
      @confirmed_enquiries = Enquiry.awaiting_completion.order 'created_at DESC'
      @cancelled_enquiries = Enquiry.cancelled.where("created_at >= ?", 1.month.ago.utc).order 'created_at DESC'
      @completed_enquiries = Enquiry.completed.where("created_at >= ?", 6.months.ago.utc).order 'created_at DESC'
      respond_to do |format|
        format.html
        format.csv { render text: Enquiry.all.order('created_at DESC').to_csv }
      end
    end

    def create
      @enquiry = Enquiry.new
      @enquiry.status = EnquiryStatus::NEW
      @enquiry.update_attributes enquiry_params
      create_address
      record_menu_details
      @enquiry.record_amount_paid!
      @enquiry.save!
      flash[:success] = 'Enquiry created'
      redirect_to edit_admin_enquiry_path(@enquiry)
    end

    def new_for_customer
      @customer = Customer.find params[:id]
      create_enquiry
      redirect_to edit_admin_enquiry_path(@enquiry)
    end

    def update
      # hack / patch to get address to update.
      perm_params = permitted_params.dup
      address = perm_params.delete(:address)
      @enquiry.update_attributes! perm_params
      @enquiry.address.update_attributes(address)

      #@enquiry.populate_total_price!
      @enquiry.ensure_processing
      flash[:success] = 'Enquiry updated'
      redirect_to edit_admin_enquiry_path
    end

    def edit
      begin
        @payment = @enquiry.stripe_payment_id ? Stripe::Charge.retrieve(@enquiry.stripe_payment_id) : nil
      rescue Stripe::InvalidRequestError
        @payment = nil
      end
    end

    def refund
      @enquiry.refund_customer
      flash[:success] = "This order has been refunded"
      redirect_to edit_admin_enquiry_path
    end

    def progress
      EnquiryStatus.progress(@enquiry)
      @enquiry.save!
    end

    def regress
      EnquiryStatus.regress(@enquiry)
      @enquiry.save!
      render :progress
    end

    def spam
      @enquiry.status = EnquiryStatus::SPAM
      @enquiry.save!
      render :progress
    end

    def test
      @enquiry.status = EnquiryStatus::TEST
      @enquiry.save!
      render :progress
    end

    def cancel
      @enquiry.status = EnquiryStatus::CANCELLED
      @enquiry.save!
      @enquiry.refund_customer
      render :progress
    end

    def set_address
      @enquiry.address_id = params[:address_id]
      @enquiry.save!
      head 204
    end

    def enquiry_address
    end

    def send_confirmation_link
      if @enquiry.status != EnquiryStatus::READY_TO_CONFIRM
        head :bad_request
        return
      end
      @enquiry_confirmation = EnquiryConfirmation.new(@enquiry)
      head :no_content
    end

    def invoice
      file = open(Storage.download("caitre_d_order_#{@enquiry.id}.pdf"))
      send_file file, filename: "caitre_d_order_#{@enquiry.id}.pdf", type: "application/pdf", :disposition => "attachment"
    end

    def address_params
      return {} if params[:enquiry].nil? || params[:enquiry][:address].nil?
      address_properties = params.require(:enquiry)
                           .require(:address)
                           .permit(Address.allowed_params)
      address_properties[:customer] = @customer
      address_properties
    end

    def update_extras
      @menu = Menu.find(params[:id])
      respond_to do |format|
        format.js
      end
    end

    def confirm_enquiry
      @enquiry.confirm_by_food_partner
      flash['success'] = "Order confirmed and invoice generated."
      redirect_to edit_admin_enquiry_path(@enquiry)
    end

private

  def permitted_params
    params.require(:enquiry).permit(
      :event_date,
      :event_time,
      :number_of_attendees,
      :additional_messages, 
      address: [:company, :line_1, :line_2, :suburb, :postcode, :parking_information]
    )
  end

    def create_enquiry
      @enquiry = Enquiry.new enquiry_params
      @enquiry.customer = @customer
      @enquiry.status = EnquiryStatus::NEW
      @enquiry.menu = @menu.as_json unless @menu.nil?
      @enquiry.save!
    end

    def find_enquiry
      @enquiry = Enquiry.find(params[:id] || params[:enquiry_id])
    end

    def enquiry_params
      return {} if params[:enquiry].nil?
      params.require(:enquiry).permit(*Factories::EnquiryFactory::ALLOWED_PARAMS)
    end

    def create_address
      if address_id.blank?
        @address = Address.create!(address_params)
      else
        @address = Address.find address_id
        @address.update_attributes!(address_params)
      end
      @enquiry.address = @address
    end

    def record_menu_details
      return if @menu.nil?
      menu_clean = @menu.as_json
      menu_clean['menu_image_file_name'] =  @menu.menu_image_file_name_url
      @enquiry.menu = menu_clean
      @enquiry.menu_extras ||= []
      t = []
      if params[:enquiry][:menu_extras]
        params[:enquiry][:menu_extras].split(',').each do |extra|
          item = PackageableItem.find(extra.to_i)
          item.nil? ? {} : t << item.to_hash
        end
      end
      @enquiry.menu_extras = t
      @enquiry.menu_content = menu_content
      @enquiry.populate_from_menu(@menu)
    end

    def record_dietary_requirements
      if params[:enquiry][:dietary_requirements]
        h = {}
        params[:enquiry][:dietary_requirements].split(';').each do |d|
          key = d.split('=>').first
          value = d.split('=>').last
          h[key] = value
        end
        @enquiry.dietary_requirements = h
      end
    end

    def address_id
      params[:enquiry][:address_id]
    end

    def menu_content
      [
        @menu.content_for_attendees(attendees, params[:enquiry][:dietary_item]),
        content_for_extras
      ].join("\n")
    end

    def attendees
      params['enquiry'].fetch('event', {}).fetch('attendees', 0)
    end

    def content_for_extras
      @enquiry.menu_extras.map do |item|
        "#{attendees} x #{item['title']} #{item['cost_string']} (added extra)"
      end.join("\n")
    end

  end
end
