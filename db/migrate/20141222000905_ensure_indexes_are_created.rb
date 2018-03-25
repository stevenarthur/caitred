class EnsureIndexesAreCreated < ActiveRecord::Migration
  def up
    add_index :status_audits, :enquiry_id
    add_index :status_audits, [:enquiry_id, :new_status]
  end
end
