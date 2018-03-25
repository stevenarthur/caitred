class UpdatePollVotesPerAnswerView < ActiveRecord::Migration
  def up
    execute 'DROP VIEW poll_votes_per_answer'
    execute <<-SQL
      CREATE VIEW poll_votes_per_answer AS
        SELECT polls.id AS poll_id, poll_answers.id AS poll_answer_id, poll_answers.answer_text, COUNT(poll_votes.id) AS votes
        FROM polls
        INNER JOIN poll_answers ON polls.id = poll_answers.poll_id
        LEFT OUTER JOIN poll_votes ON poll_answers.id = poll_votes.poll_answer_id
        GROUP BY polls.id, poll_answers.id, poll_answers.answer_text
    SQL
  end
  def down
    execute 'DROP VIEW poll_votes_per_answer'
    execute <<-SQL
      CREATE VIEW poll_votes_per_answer AS
        SELECT polls.id AS poll_id, poll_answers.id AS poll_answer_id, poll_answers.answer_text, COUNT(poll_votes.id) AS votes
        FROM polls
        INNER JOIN poll_answers ON polls.id = poll_answers.poll_id
        INNER JOIN poll_votes ON poll_answers.id = poll_votes.poll_answer_id
        GROUP BY polls.id, poll_answers.id, poll_answers.answer_text
    SQL
  end
end
