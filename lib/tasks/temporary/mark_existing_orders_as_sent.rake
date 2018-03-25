namespace :caitre_d do
  desc "Reminder columns have been added in. This marks existing enquiries as sent so that these do not get delivered"

  task migrate_reminders: :environment do
    Enquiry.all.find_each do |enquiry|
      enquiry.update_attributes!(partner_reminder_sent: true,
                                 feedback_email_sent: true)
    end
  end

end
