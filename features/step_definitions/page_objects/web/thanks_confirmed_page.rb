module Web
  class ThanksConfirmedPage < BasePage
    def visible?
      @page.find('#js-thanks-confirmed').visible?
    end
  end
end
