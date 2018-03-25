class PollVote < ActiveRecord::Base
  belongs_to :poll_answer

  scope :by_poll_answer, lambda {|poll_answer|
    where(poll_answer_id: poll_answer.id)
  }
  scope :by_identifier, lambda {|identifier|
    where(user_identifier: identifier)
  }
end
