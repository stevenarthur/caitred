module Admin
  class SupplierPreviewEmailPage < BasePage
    def fill_intro_text(text)
      @page.find('#js-intro-text')
      fill_in 'js-intro-text', text
    end

    def send_email
      @page.find('.js-modal-send-email').click
    end

    def send_for_supplier(company_name)
      @page.find(".js-send-email[data-supplier='#{company_name}']").click
      @page.find('.alert-success')
    end
  end
end
