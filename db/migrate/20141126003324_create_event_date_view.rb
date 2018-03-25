class CreateEventDateView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      create view enquiry_event_date_and_attendees as
        select id, event-> 'attendees' as attendees,
        event-> 'event_date' as event_date,
        to_date(event->>'event_date', 'DD Month YYYY')
        from enquiries
        where status in ('#{EnquiryStatus::CONFIRMED}', '#{EnquiryStatus::DELIVERED}', '#{EnquiryStatus::COMPLETED}')
        order by id
    SQL
    execute sql
  end

  def down
    execute 'drop view enquiry_event_date_and_attendees'
  end
end
