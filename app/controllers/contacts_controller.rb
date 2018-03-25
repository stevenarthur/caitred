class ContactsController < ApplicationController
  layout 'website'

  def new
  	@contact = Contact.new
  end

  def create
  	@contact = Contact.create! contact_params
    flash[:success] = 'Parcipation sent'
    redirect_to share_contest_path
  end

  private

  def contact_params
    params.require(:contact).permit(:company, :name, :email)
  end

end
