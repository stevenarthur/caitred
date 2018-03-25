class AddReminderBooleansToEnquiry < ActiveRecord::Migration
  def change
    add_column :enquiries, :partner_reminder_sent, :boolean, default: false, null: false
    add_column :enquiries, :feedback_email_sent, :boolean, default: false, null: false
  end
end
