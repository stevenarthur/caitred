module Web
  class QuotesController < WebsiteController
    layout 'website'

    def new
      @quote = Quote.new
      @food_partner = FoodPartner.find(params[:food_partner_id]) if params[:food_partner_id]
    end

    def create
      build_quote
      if @quote.save
        process_quote
        redirect_to submitted_quote_path
      else
        render :new
      end
    end

    def submitted
    end

  private

    def build_quote
      @food_partner = FoodPartner.find(params[:quote][:food_partner_id]) if params[:quote][:food_partner_id].present?
      @quote = @food_partner ? @food_partner.quotes.create(quote_params) : Quote.create(quote_params)
    end

    def process_quote
      check_for_spam
      notify_team_of_new_quote unless @quote.spam?
      ProcessQuoteWorker.perform_async(@quote.id)
    end

    def check_for_spam
      is_spam = Akismet.spam?(request.ip, request.user_agent, text: @quote.message)
      @quote.update_attribute('spam', true) if is_spam
    end

    def notify_team_of_new_quote
      TeamMailer.new_quote_notice(@quote).deliver_later
    end

    def quote_params
      params.require(:quote).permit(:name, :email, :phone, :postcode, :message, :contact_method, :food_partner_id)
    end

  end
end
