module Factories
  class PollFactory
    ALLOWED_PARAMS = [
      :title,
      :description_html,
      :tag
    ]

    ALLOWED_ANSWER_PARAMS = [
      {
        answers: [
          :id,
          :answer_text,
          :order
        ]
      }
    ]

    def self.new_from_http_params(params)
      properties = params.permit(ALLOWED_PARAMS)
      properties[:id] = SecureRandom.uuid
      poll = Poll.create! properties
      update_answers(poll, params)
      poll
    end

    def self.update_from_http_params(poll, params)
      properties = params.permit(ALLOWED_PARAMS)
      poll.update_attributes! properties
      update_answers(poll, params)
    end

    def self.update_answers(poll, params)
      answer_params = params.permit(ALLOWED_ANSWER_PARAMS)
      answer_params[:answers].each do |answer|
        if answer[:id].blank?
          create_answer(answer, poll)
        else
          update_answer(answer)
        end
      end
    end

    def self.create_answer(answer, poll)
      return if answer[:answer_text].blank?
      answer[:poll_id] = poll.id
      answer[:id] = SecureRandom.uuid
      PollAnswer.create! answer
    end

    def self.update_answer(answer)
      poll_answer = PollAnswer.find(answer[:id])
      if answer[:answer_text].blank?
        poll_answer.destroy!
      else
        poll_answer.update_attributes! answer
      end
    end
  end
end
