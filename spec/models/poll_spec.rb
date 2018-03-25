require 'rails_helper'

describe Poll do
  describe '#results' do
    let(:poll) do
      poll = create(:poll)
      answer_1 = create(:poll_answer, poll: poll)
      answer_2 = create(:poll_answer, poll: poll)
      create(:poll_vote, poll_answer: answer_1)
      create(:poll_vote, poll_answer: answer_1)
      create(:poll_vote, poll_answer: answer_2)
      create(:poll_vote, poll_answer: answer_2)
      poll
    end
    let(:results) { poll.results }

    it 'has a row for each of the answers' do
      expect(results.size).to eq 2
    end

    it 'gets the number of votes' do
      expect(results.first[:votes]).to eq '2'
    end
  end

  describe '#can_vote?' do
    let(:identifier) { 'abc' }
    let(:poll) do
      poll = create(:poll)
      answer_1 = create(:poll_answer, poll: poll)
      create(:poll_vote, poll_answer: answer_1, user_identifier: identifier)
      poll
    end

    it 'is true for a new identifer' do
      expect(poll.can_vote?('def')).to eq true
    end

    it 'is false for an identifier that has voted' do
      expect(poll.can_vote?('abc')).to eq false
    end
  end

  describe '#ordered_answers' do
    let(:poll) { create(:poll) }
    let!(:answer_1) { create(:poll_answer, poll: poll, order: 1) }
    let!(:answer_2) { create(:poll_answer, poll: poll, order: 3) }
    let!(:answer_3) { create(:poll_answer, poll: poll, order: 2) }

    it 'gets a list of the answers in order' do
      expect(poll.ordered_answers.first).to eq answer_1
      expect(poll.ordered_answers.second).to eq answer_3
      expect(poll.ordered_answers.third).to eq answer_2
    end
  end
end
