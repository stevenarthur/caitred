class CreateIndexes < ActiveRecord::Migration
  def up
    sql = <<-SQL
      CREATE INDEX enquiry_id_idx on status_audits (enquiry_id)
      CREATE INDEX enquiry_id_new_idx on status_audits (enquiry_id,new_status)
    SQL
  end
end
