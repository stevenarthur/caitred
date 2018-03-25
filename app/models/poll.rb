class Poll < ActiveRecord::Base
  has_many :poll_answers

  def results
    sql = <<-SQL
      select * from poll_votes_per_answer
      where poll_id = '#{id}'
    SQL
    @results ||= PollResults.new(results_columns, Poll.connection.select_rows(sql))
  end

  def can_vote?(user_identifier)
    poll_answers.all? do |answer|
      PollVote.by_poll_answer(answer)
        .by_identifier(user_identifier)
        .empty?
    end
  end

  def ordered_answers
    poll_answers.order(:order)
  end

  private

  def results_columns
    columns = Poll.connection.columns('poll_votes_per_answer')
              .map(&:name)
              .map(&:to_sym)
    Hash[columns.map.with_index.to_a]
  end
end
