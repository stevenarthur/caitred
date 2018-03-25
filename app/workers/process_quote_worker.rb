class ProcessQuoteWorker
  include Sidekiq::Worker

  def perform(quote_id)
    @quote = Quote.find(quote_id)
    if !@quote.spam?
      trello_card = Trello::Card.new()
      trello_card.list_id = ENV["TRELLO_JOB_BOARD_LIST_ID"]
      trello_card.name = "#{@quote.name} #{@quote.date.strftime("%e %B %Y") if @quote.date.present?} \n"
      trello_card.desc = "Company: #{@quote.company} \n" if @quote.company.present?
      trello_card.desc = "Email: #{@quote.email} \n" if @quote.email.present?
      trello_card.desc += "Phone: #{@quote.phone} \n" if @quote.phone.present?
      trello_card.desc += "Postcode: #{@quote.postcode} \n" if @quote.postcode.present?
      trello_card.desc += "Message: \n#{@quote.message}" if @quote.message.present?
      trello_card.save
    end
  end

end
