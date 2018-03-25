class EnquiryRow < BasePage
  def initialize(element, page)
    super(page)
    @element = element
  end

  def edit
    @element.find('.js-enquiry-id').click
    @page.find('h2.js-enquiry-title')
  end

  def mark_test
    @element.find('.js-mark-enquiry-test').click
    edit
  end

  def mark_spam
    @element.find('.js-mark-enquiry-spam').click
    edit
  end

  def progress
    @element.find('.js-progress-enquiry').click
    edit
  end
end
