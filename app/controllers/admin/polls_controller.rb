module Admin
  class PollsController < AdminController
    before_action :require_admin_authentication
    before_action :find_poll, only: [:edit, :update]

    def new
      @poll = Poll.new
      @poll_answers = []
    end

    def index
      @polls = Poll.all
    end

    def create
      @poll = Factories::PollFactory.new_from_http_params(params.require(:poll))
      flash[:success] = 'Poll created'
      redirect_to edit_admin_poll_path(@poll)
    end

    def edit
      @poll_answers = @poll.poll_answers.ordered
    end

    def update
      Factories::PollFactory.update_from_http_params(@poll, params.require(:poll))
      flash[:success] = 'Poll details updated'
      redirect_to edit_admin_poll_path(@poll)
    end

    private

    def find_poll
      @poll = Poll.find params[:id]
    end
  end
end
