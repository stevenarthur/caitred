class AddVotingTables < ActiveRecord::Migration
  def up
    create_table :polls, id: false do |t|
      t.uuid :id, primary_key: true
      t.string :title
      t.string :description_html
      t.timestamps
    end

    create_table :poll_answers, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :poll_id
      t.string :answer_text
      t.integer :order
      t.timestamps
      t.foreign_key :polls
    end

    create_table :poll_votes, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :poll_answer_id
      t.timestamps
      t.string :user_email
      t.foreign_key :poll_answers
    end

    execute <<-SQL
      CREATE VIEW poll_votes_per_answer AS
        SELECT polls.id AS poll_id, poll_answers.id AS poll_answer_id, poll_answers.answer_text, COUNT(poll_votes.id) AS votes
        FROM polls
        INNER JOIN poll_answers ON polls.id = poll_answers.poll_id
        INNER JOIN poll_votes ON poll_answers.id = poll_votes.poll_answer_id
        GROUP BY polls.id, poll_answers.id, poll_answers.answer_text
    SQL
  end

  def down
    execute 'DROP VIEW poll_votes_per_answer'
    drop_table :poll_votes
    drop_table :poll_answers
    drop_table :polls
  end
end
