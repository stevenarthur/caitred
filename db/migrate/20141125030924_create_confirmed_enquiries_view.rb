class CreateConfirmedEnquiriesView < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE VIEW confirmed_enquiries AS
        select distinct on (enquiry_id) e.*, s.created_at as confirmed_at
        from status_audits s
        inner join enquiries e on s.enquiry_id = e.id
        where new_status = '#{EnquiryStatus::CONFIRMED}'
        and e.status IN ('#{EnquiryStatus::CONFIRMED}', '#{EnquiryStatus::DELIVERED}','#{EnquiryStatus::COMPLETED}')
        order by enquiry_id, s.created_at asc;
    SQL
    execute sql
  end

  def down
    execute 'DROP VIEW confirmed_enquiries'
  end
end
