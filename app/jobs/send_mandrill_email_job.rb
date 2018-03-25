class SendMandrillEmailJob < ActiveJob::Base
  queue_as :default

  def perform(template, template_content, mail_message)
    mandrill = Mandrill::API.new ENV['MANDRILL_API_KEY']
    mandrill.messages.send_template(template, template_content, mail_message)
  end
end
