require 'rails_helper'

describe PollAnswer do

  describe '#add_vote' do
    let(:poll_answer) { create(:poll_answer) }
    let(:identifier) { 'abc' }

    before do
      poll_answer.add_vote(identifier)
    end

    it 'adds a vote' do
      expect(poll_answer.poll_votes.size).to eq 1
    end

    it 'sets the user_identifier' do
      expect(poll_answer.poll_votes.first.user_identifier).to eq 'abc'
    end
  end
end
