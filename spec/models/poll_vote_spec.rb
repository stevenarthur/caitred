require 'rails_helper'

describe PollVote do
  let(:poll_answer) { create(:poll_answer) }
  let!(:vote_1) do
    create(
      :poll_vote,
      poll_answer: poll_answer,
      user_identifier: 'abc'
    )
  end
  let!(:vote_2) do
    create(
      :poll_vote,
      poll_answer: poll_answer,
      user_identifier: 'def'
    )
  end

  describe '#by_poll_answer' do
    let(:votes) { PollVote.by_poll_answer(poll_answer) }

    it 'returns the matching vote' do
      expect(votes).to include vote_1
      expect(votes).to include vote_2
    end
  end

  describe '#by_identifier' do
    let(:votes) { PollVote.by_identifier('abc') }

    it 'returns the matching vote' do
      expect(votes).to include vote_1
    end

    it 'does not include other votes' do
      expect(votes).not_to include vote_2
    end
  end
end
