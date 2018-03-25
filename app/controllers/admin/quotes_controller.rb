module Admin
  class QuotesController < AdminController
    before_action :find_quote, only: [:edit, :update, :destroy]
    before_action :require_admin_authentication

    def index
      @quotes = Quote.all.order :created_at
    end

    def edit

    end

    def new
      @quote = Quote.new
    end

    def create
      @quote = Quote.new
      update_quote('created')
    end

    def enquiries
      @enquiries = @customer.enquiries
    end

    def update
      update_quote('updated')
    end

    def destroy
      @quote.destroy
      flash[:success] = "Quote deleted"
      redirect_to admin_quotes_path
    end

    private

    def update_quote(action_name)
      if @quote.update_attributes quote_params
        flash[:success] = "Quote #{action_name}"
        redirect_to admin_quotes_path
      else
        flash[:error] = error_message
        render :edit, status: 400
      end
    end

    def error_message
      @quote.errors.messages.map do
        |key, value| "#{key} #{value.join(' and ')}"
      end.join(', ').capitalize + '.'
    end

    def find_quote
      @quote = Quote.find(params[:id] || params[:quote_id])
    end

    def quote_params
      params.require(:quote).permit(:name, :email, :date, :postcode, :company,
                                    :phone, :message, :food_partner_id)
    end
  end
end
