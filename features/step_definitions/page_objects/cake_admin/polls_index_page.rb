module Admin
  class PollsIndexPage < BasePage
    def self.url
      '/admin/polls'
    end

    def poll_count
      @page.all('.js-poll').size
    end

    def add_poll
      @page.find('#js-add-poll').click
    end

    def contains?(poll_name)
      @page.all('.js-poll-name').any? do |row|
        row.text == poll_name
      end
    end

    def edit_poll(poll_name)
      @page.all('.js-poll-name').find do |row|
        row.text == poll_name
      end.click
    end

    def save_poll
      @page.find('#js-save-poll').click
    end
  end
end
