desc 'Check and Send Reminder Emails'
namespace :caitre_d do
  task :process_reminder_emails => :environment do

    reminder_enquiries_to_process = Enquiry.where(partner_reminder_sent: false, status: 'Confirmed')
    reminder_enquiries_to_process.each do |enquiry|
      if enquiry.partner_reminder_due?
        FoodPartnerMailer.reminder_notice(enquiry).deliver_later()
        enquiry.update_attributes(partner_reminder_sent: true)
      end
    end

    feedback_enquiries_to_process = Enquiry.where(feedback_email_sent: false, status: 'Completed')
    feedback_enquiries_to_process.each do |enquiry|
      if enquiry.feedback_email_due?
        CustomerEmailFeedbackWorker.perform_async(enquiry.id) 
        enquiry.update_attributes(feedback_email_sent: true)
      end
    end

  end
end
