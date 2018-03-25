# rubocop:disable Metrics/ClassLength
module Web
  class EnquiriesController < WebsiteController
    before_action :find_menu, only: [:new, :create]
    #skip_before_filter :verify_authenticity_token, :only => [:sms_reply]

    require 'open-uri'

    def supplier_confirmation
      @enquiry = Enquiry.find(params[:enquiry_id])
      if check_token(@enquiry, params[:token])
        @enquiry.confirm_by_food_partner
        flash[:success] = 'Enquiry confirmed!!! :)'
        notice_team_partner_confirmation
      else
        token_fail
      end
    end

    def supplier_refusal
      @enquiry = Enquiry.find(params[:enquiry_id])
      if check_token(@enquiry, params[:token])
        @enquiry.status = EnquiryStatus::CANCELLED
        @enquiry.save!
        flash[:success] = 'Enquiry refused!'
      else
        token_fail
      end
    end

    def invoice
      @enquiry = Enquiry.find(params[:id])
      if @enquiry.customer == current_customer
        file = open(Storage.download("caitre_d_order_#{@enquiry.id}.pdf"))
        send_file file, filename: "caitre_d_order_#{@enquiry.id}.pdf", type: "application/pdf", :disposition => "attachment"
      else
        redirect_to my_account_path
      end
    end

    private
    
    def notice_team_partner_confirmation
      TeamMailer.food_partner_confirmation_notice(@enquiry).deliver_later
    end

    def check_token(enquiry, token)
      token == enquiry.token && enquiry.status == "Waiting on Supplier"
    end

    def token_fail
      flash[:error] = "We cannot identify that enquiry."
      redirect_to supplier_fail_path
    end
  end
end
# rubocop:enable Metrics/ClassLength
