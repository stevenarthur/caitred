class PollAnswer < ActiveRecord::Base
  belongs_to :poll
  has_many :poll_votes

  scope :ordered, -> { order(:order) }

  def add_vote(identifier)
    fail 'Already voted' if voted?(identifier)
    PollVote.create!(
      id: SecureRandom.uuid,
      poll_answer: self,
      user_identifier: identifier
    )
  end

  private

  def voted?(identifier)
    !PollVote.by_poll_answer(self)
      .by_identifier(identifier)
      .empty?
  end
end
