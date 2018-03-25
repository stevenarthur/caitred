module Web
  class ThankYouPage < BasePage
    def submit
      @page.find('#js-create-account-submit').click
    end
  end
end
