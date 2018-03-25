namespace :enquiries do
  desc "Update event data away from JSON"

  task extract_event_date_and_time: :environment do
    ActiveRecord::Base.transaction do

      Enquiry.find_each do |enquiry|
        unless enquiry.event_time.present?
          enquiry.event_time = enquiry.event.event_time
        end
        unless enquiry.event_date.present?
          enquiry.event_date = enquiry.event.event_date
        end
        unless enquiry.number_of_attendees.present?
          enquiry.number_of_attendees = enquiry.event.attendees
        end
        enquiry.save
      end

    end

    puts " All done now!"
  end
end
