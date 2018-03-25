class CreateStatusAuditTable < ActiveRecord::Migration
  def change
    create_table :status_audits do |t|
      t.integer :enquiry_id
      t.string :old_status
      t.string :new_status
      t.foreign_key :enquiries
      t.timestamps
    end
  end
end
