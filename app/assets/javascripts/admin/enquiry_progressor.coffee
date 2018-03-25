class Cake.EnquiryProgressor

  setupEnquiryProgress: =>
    $('.js-progress-enquiry').off 'click'
    $('.js-progress-enquiry').on 'click', @progressEnquiry
    $('.js-regress-enquiry').off 'click'
    $('.js-regress-enquiry').on 'click', @regressEnquiry
    $('.js-cancel-enquiry').off 'click'
    $('.js-cancel-enquiry').on 'click', @cancelEnquiry
    $('.js-mark-enquiry-test').off 'click'
    $('.js-mark-enquiry-test').on 'click', @markEnquiryTest
    $('.js-mark-enquiry-spam').off 'click'
    $('.js-mark-enquiry-spam').on 'click', @markEnquirySpam

  progressEnquiry: (e) =>
    @updateEnquiry(e, "progress")

  regressEnquiry: (e) =>
    @updateEnquiry(e, "regress")

  cancelEnquiry: (e) =>
    @updateEnquiry(e, "cancel")

  markEnquiryTest: (e) =>
    @updateEnquiry(e, "test")

  markEnquirySpam: (e) =>
    @updateEnquiry(e, "spam")

  refreshStatus: (data) =>
    Cake.enquiryProgressed = true
    data.enquiryId = @enquiryId
    statusContent = $('.js-status-content')
    if statusContent.length == 1
      html = Cake.Templates.EnquiryStatus(data)
      statusContent.html(html)
    statusRow = $(".js-status-row[data-id=#{@enquiryId}]")
    if statusRow.length == 1
      statusRow.find('.js-status').text(data.new_status)
      html = Cake.Templates.EnquiryStatusButtons(data)
      statusRow.find('.js-status-buttons').html(html)
    @setupEnquiryProgress()

  updateEnquiry: (e, action) ->
    Cake.enquiryProgressed = false
    e.preventDefault()
    data = $(e.target).data();
    @enquiryId = data['id'];
    url = "/admin/enquiries/#{@enquiryId}/#{action}.json"
    promise = $.post(url)
    promise.done @refreshStatus
      .fail @showError

  showError: ->
    Cake.enquiryProgressed = true
    errorMsg = $('<div />').addClass('alert alert-danger').text('This Enquiry could not be updated.')
    $('.js-enquiry-title').parent().append(errorMsg)
