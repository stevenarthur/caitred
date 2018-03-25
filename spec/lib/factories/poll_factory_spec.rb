require 'rails_helper'

module Factories
  describe PollFactory do

    describe '#new_from_http_params' do

      let(:params) do
        ActionController::Parameters.new(
          title: 'a poll',
          description_html: 'something',
          tag: 'my_poll',
          answers: [
            {
              order: 1,
              answer_text: 'yes'
            },
            {
              order: 2,
              answer_text: 'no'
            }
          ]
        )
      end
      let(:poll) { PollFactory.new_from_http_params(params) }

      it 'creates a new poll' do
        expect(poll).not_to be_nil
      end

      it 'sets the title' do
        expect(poll.title).to eq 'a poll'
      end

      it 'sets the tag' do
        expect(poll.tag).to eq 'my_poll'
      end

      it 'sets the description' do
        expect(poll.description_html).to eq 'something'
      end

      it 'adds the answers' do
        expect(poll.poll_answers.size).to eq 2
      end

      context 'with blank answers' do
        let(:params) do
          ActionController::Parameters.new(
            title: 'a poll',
            description_html: 'something',
            answers: [
              {
                order: '',
                answer_text: ''
              },
              {
                order: '',
                answer_text: ''
              }
            ]
          )
        end

        it 'does not add blank answers' do
          expect(poll.poll_answers.size).to eq 0
        end
      end
    end

    describe '#update_from_http_params' do

      let(:params) do
        ActionController::Parameters.new(
          title: 'yes or no',
          description_html: 'whether people think yes or no',
          answers: [
            {
              id: poll_answer.id,
              order: 1,
              answer_text: 'hello hello'
            },
            {
              id: '',
              order: 2,
              answer_text: 'no'
            }
          ]
        )
      end
      let(:poll) { create(:poll_with_answers) }
      let(:poll_answer) { poll.poll_answers[0] }

      before do
        PollFactory.update_from_http_params(poll, params)
        poll.reload
        poll_answer.reload
      end

      it 'sets the title' do
        expect(poll.title).to eq 'yes or no'
      end

      it 'sets the description' do
        expect(poll.description_html).to eq 'whether people think yes or no'
      end

      it 'updates the answers' do
        expect(poll_answer.answer_text).to eq 'hello hello'
      end

      it 'adds the answers' do
        expect(poll.poll_answers.size).to eq 2
      end
    end

    describe '#update_from_http_params with blank answers' do
      let(:poll) { create(:poll_with_answers) }
      let(:poll_answer) { poll.poll_answers[0] }
      let(:params) do
        ActionController::Parameters.new(
          title: 'a poll',
          description_html: 'something',
          answers: [
            {
              id: poll_answer.id,
              order: '',
              answer_text: ''
            },
            {
              order: '',
              answer_text: ''
            }
          ]
        )
      end

      before do
        PollFactory.update_from_http_params(poll, params)
        poll.reload
      end

      it 'does not add blank answers' do
        expect(poll.poll_answers.size).to eq 0
      end

      it 'deletes existing answers that are now blank' do
        expect(poll.poll_answers.size).to eq 0
      end
    end

  end
end
