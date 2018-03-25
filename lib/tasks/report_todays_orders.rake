namespace :caitre_d do
  desc "Run task to notify slack of the days orders"

  task report_todays_orders: :environment do
    e = Enquiry.placed_today.sum(:total_cost).to_f
    string_value = ActionController::Base.helpers.number_to_currency(e)

    if (e >= 5000.00)
      color = "#12b408"
      message = "This is #{ActionController::Base.helpers.number_to_currency(e - 5000.00)} more than the $5k target"
    else
      color = "#ea2e2e"
      message = "This is #{ActionController::Base.helpers.number_to_currency(5000.00 - e)} less than the $5k target"
    end

    payload = {
      "username": "Caitre'd Bot",
      "icon_url": "https://www.caitre-d.com/assets/boticon-952a754b92848f09584bcc7df0aac157.png",
      "attachments": [
          {
              "fallback": "Today we brought in #{string_value}",
              "color": color,
              "author_name": "Cake",
              "title": "Today we brought in #{string_value}",
              "text": message,
              "ts": DateTime.current.to_i
          }
      ]
    }.to_json

    webhook_url = "https://hooks.slack.com/services/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"
    puts HTTParty.post(webhook_url, body: payload, headers: { 'Content-Type' => 'application/json' })

  end
end
