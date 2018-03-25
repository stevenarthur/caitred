module Admin
  class SupplierCommunicationsController < AdminController
    before_action :require_admin_authentication, except: [:incoming_mail]
    layout 'admin'

    # Triggered in Cake "Send Supplier Email"
    def create
      @enquiry = Enquiry.find params[:enquiry_id]
      content = params[:email_content].gsub("\n", '<br>')
      FoodPartnerMailer.new_order_notice(@enquiry, content).deliver_later
      SupplierCommunication.create! comm_params
      @enquiry.wait_on_supplier
      head :ok
    end

    private

    def comm_params
      {
        email_html: params[:email_content], #@mail.message_html,
        enquiry: @enquiry,
        food_partner: @enquiry.food_partner,
        from_email: Cake::Application.config.youchews_email_from_address,
        from_name: Cake::Application.config.youchews_email_name,
        to_email: @enquiry.food_partner.email,
        to_name: @enquiry.food_partner.contact_name,
        email_subject: "Job for #{@enquiry.event_date.strftime("%e %B %Y")} (Order ##{@enquiry.id})"
      }
    end
  end
end
