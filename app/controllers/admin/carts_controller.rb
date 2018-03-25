class Admin::CartsController < AdminController
  def index
    @enquiries = Enquiry.order(id: :desc).in_cart
  end
  
  def make_enquiry
    @enquiry = Enquiry.find(params[:id])
    @enquiry.status = EnquiryStatus::NEW
    @enquiry.save!
    send_emails 
    flash[:notice] = "Enquiry Created"
    redirect_to admin_carts_path
  end


private
  def send_emails
    notice_team_new_order
  end

  def send_customer_email
    CustomerMailer.new_order_confirmation(@enquiry).deliver_later
  end

  def notice_team_new_order
    TeamMailer.new_order_notice(@enquiry).deliver_later
  end

end
