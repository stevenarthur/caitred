module Web
  class ThanksForRegistering < BasePage
    def loaded?
      @page.find('.js-thanks-for-registering')
      true
    end
  end
end
