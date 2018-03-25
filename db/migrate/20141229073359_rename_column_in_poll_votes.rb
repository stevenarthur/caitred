class RenameColumnInPollVotes < ActiveRecord::Migration
  def change
    rename_column :poll_votes, :user_email, :user_identifier
  end
end
