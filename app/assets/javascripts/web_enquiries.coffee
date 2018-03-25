Cake.WebEnquiries = implementing Cake.JudgeForm, class Cake._WebEnquiries

  @ready: ->

    $('.js-tooltip').tooltip
      placement: 'bottom'
    $("#js-sample-menus").on 'click', ->
      addInfo = $("#js-additional-info")
      currentValue = addInfo.val()
      addInfo.val("Please send me some sample menus. #{currentValue}")

    new Cake.Datepicker($('.js-datepicker'), $('#js-show-datepicker'))
    new Cake.Timepicker($('.js-timepicker'), $('#js-show-timepicker'))

    #calculator = new Cake.EnquiryCalculator()
    #calculator.setPrice(window.menuCost)
    #calculator.setDelivery(window.deliveryCost)

    #priceView = new Cake.EnquiryPriceView($('.js-price-info-container'), calculator, $('#js-attendees'), $('.js-extra'))
    #priceView.render()

    Cake.WebEnquiries.enquiry = enquiry = new Cake.WebEnquiries()
    enquiry.setupForm()

    $(document).on(Cake.Events.VALIDATION_COMPLETE, ->
      if $('#js-email').siblings('.js-errors').text().length > 0
        $('html, body').animate({
          scrollTop: $("#js-email").offset().top
        }, 500);
      #else
      #  #$(".order-button").trigger("click")
    )

    $(".js-has-button").on 'change', (e) ->
      $(e.target).closest('.btn').toggleClass 'selected'

    $('#js-edit-address').on 'click', ->
      $('.js-address-form').show()
      $('.js-address-text').hide()

    $('#js-add-address').on 'click', ->
      $("#js-address-#{field}").val('') for field in ['line-1', 'line-2', 'suburb', 'postcode', 'parking-information']
      $('#js-address-id').val('')
      $('.js-address-form').show()
      $('.js-address-text').hide()


    if($('.checkout').length > 0)
      top = $('.checkout').offset().top - parseFloat($('.checkout').css('marginTop').replace(/auto/,0))
      $(window).scroll ->
        y = $(this).scrollTop()
        if y >= top
          $('.checkout').addClass 'fixed'
        else
          $('.checkout').removeClass 'fixed'

    $("#more-info").change ->
      $("#additional_messages").val( $(this).val() )

    $('.dietary-select').change ->
      s = ''
      $('.dietary-select').each ->
        s = s + $(this).attr('id') + "=>" + $(this).val() + ";"
      $('#dietary').val(s)


    #$("#price-button").click ->
      #$(".order-button").trigger("click")

    $('.item').change ->
      s = ''
      $('.item:checked').each ->
        s = s + $(this).attr("data-item-id") + ","
      $('#extras').val(s)
      calculateprice()

    calculateprice = ->
      people = parseFloat($('#attendees').text())
      price = $('#price').attr("data-price-per-person")
      delivery = parseFloat($('#delivery').attr("data-delivery-cost"))
      GST_RATE = 0.1
      extra = 0
      $('.item:checked').each ->
        item_price = parseFloat($(this).attr("data-item-price"))
        extra += (item_price * people)
      gst = GST_RATE * ((people * price) + extra + delivery)
      subtotal = gst + (people * price) + extra + delivery
      fees = 30/97.1 + (2.9/97.1) * subtotal
      total = subtotal + fees
      $('#extra').text('$ ' + extra.toFixed(2))
      $('#fees').text('$ ' + fees.toFixed(2))
      $('#gst').text('$ ' + gst.toFixed(2))
      $('#total').text('$ ' + total.toFixed(2))
      $('.total-button').text('$ ' + total.toFixed(2))

    calculateprice()
    #judge.validate document.getElementById('js-address-line-1')

  name: ->
    "enquiry"

  fieldsToValidate: ->
    fields = ['js-email', 'js-first-name', 'js-last-name', 'js-address-line-1']

  getMessage: ->
    "Please enter a valid email address."
