$ ->
  $('#js-send-email').on 'click', (e) ->
    e.preventDefault()
    postData = { email_content: $('#js-email-content').val() }
    $.post(sendOrderEmailUrl, postData)
      .done (response) ->
        successMsg = $('<div />').addClass('alert alert-success').text('Email sent.')
        $('.js-supplier-email-box').html(successMsg)
      .fail (response) ->
        errorMsg = $('<div />').addClass('alert alert-danger').text('Email could not be sent.')
        $('.js-supplier-email-box').append(errorMsg)

  $('.js-email-subject').hover (e) ->
    target = $(e.target)
    target.siblings('.js-email-content').show()
  , (e) ->
    target = $(e.target)
    target.siblings('.js-email-content').hide()



Cake.EnquiryForm = implementing Cake.JudgeForm, class Cake._EnquiryForm

  constructor: (@$elem) ->
    Cake.EnquiryForm.loaded = false
    new Cake.Datepicker(@$elem.find('.js-datepicker'), @$elem.find('#js-show-datepicker'))
    new Cake.Timepicker(@$elem.find('.js-timepicker'), @$elem.find('.js-timepicker'))

    @$elem.find('.js-tooltip').tooltip
      placement: 'bottom'

    $('#menu-selector').change ->
      menu_id = $(this).val()
      $.ajax
        type: "GET",
        url: "/admin/enquiries/update_extras/" + menu_id

    customerAutocomplete = new Cake.CustomerAutocomplete @$elem.find('#js-customer-field'), @$elem.find("#js-customer-id")
    @setupForm()
    new Cake.EnquiryProgressor().setupEnquiryProgress()
    new Cake.Addresses().setupLinks()

    @addViewTrigger('#js-show-supplier-comms', '#js-supplier-comms')
    @addViewTrigger('#js-show-customer-conf', '#js-customer-conf')
    @addViewTrigger('#js-show-reporting-details', '#js-reporting-details')
    @addViewTrigger('#js-show-customer-details', '.js-customer-details')
    @addViewTrigger('#js-show-invoicing-details', '#js-invoicing-details')

    @$elem.find('#js-send-email').on 'click', (e) ->
      e.preventDefault()
      postData = { email_content: $('#js-email-content').val() }
      $.post(sendOrderEmailUrl, postData)
        .done (response) ->
          successMsg = $('<div />').addClass('alert alert-success').text('Email sent.')
          $('.js-supplier-email-box').html(successMsg)
        .fail (response) ->
          errorMsg = $('<div />').addClass('alert alert-danger').text('Email could not be sent.')
          $('.js-supplier-email-box').append(errorMsg)

    @$elem.find('#js-generate-invoice').on 'click', (e) ->
      e.preventDefault()
      resultDiv = $('.js-invoice-generation-content')
      resultDiv.html('Generating invoice, please wait ...')
      promise = $.post(generageInvoiceUrl)
      promise.done(->
        successMsg = $('<div />').addClass('alert alert-success').text('Invoice created in Xero.')
        resultDiv.html(successMsg).removeClass('spinner')
      ).fail(->
        errorMsg = $('<div />').addClass('alert alert-danger').text('Invoice could not be created.')
        resultDiv.html(errorMsg).removeClass('spinner')
      )

    Cake.EnquiryForm.loaded = true

    @$elem.find('.js-send-confirm-link').on 'click', (e) ->
      e.preventDefault()
      promise = $.post(window.sendConfLinkUrl)
      promise.done(->
        successMsg = $('<div />').addClass('alert alert-success').text('Email sent.')
        $('.js-confirm-button').html(successMsg)
      ).fail(->
        errorMsg = $('<div />').addClass('alert alert-danger').text('Email could not be sent.')
        $('.js-confirm-button').html(errorMsg)
      )

  name: ->
    "enquiry"

  fieldsToValidate: ->
   ['js-customer-field']

  addViewTrigger: (trigger, showDiv) ->
    $(trigger).click (e) ->
      $(showDiv).show()
      $(trigger).closest('.js-view-button-container').hide()

  destroyForm: ->
    $(".js-judge-validate-#{@name()}").off('click')
    @$elem.add('*').off()
