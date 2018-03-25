module Admin::QuotesHelper

  def quote_form_url
    return admin_quotes_path if @quote.id.nil?
    admin_quote_path(@quote)
  end

end
