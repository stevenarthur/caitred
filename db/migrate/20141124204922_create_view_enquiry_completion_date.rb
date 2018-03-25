class CreateViewEnquiryCompletionDate < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE VIEW completed_enquiries as
        select distinct on (enquiry_id) *
        from status_audits
        where new_status = 'Completed'
        order by enquiry_id, created_at desc;

    SQL
    execute sql
  end

  def down
    execute 'DROP VIEW completed_enquiries'
  end
end
