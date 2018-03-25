Cake.EnquiryPopup = implementing Cake.JudgeForm, class Cake._EnquiryPopup

  constructor: (@$elem, @url, @attendeesElem, @postcode) ->

  show: ->

    attendees = @attendeesElem.val() if @attendeesElem
    if attendees
        @url = @url + "&attendees=#{attendees}"
    @$elem.modal
      remote: @url,
      backdrop: 'static'

    @$elem.on('hidden.bs.modal', (e) =>
      $(e.target).removeData('bs.modal')
      @datePicker.destroy()
      @$elem.find('.modal-content').html("<div class='spinner'>&nbsp;</div>")
    )

    @$elem.on('loaded.bs.modal', (e) =>
      #alert(@postcode)
      @$elem.find('.js-tooltip').tooltip()
      @datePicker = new Cake.Datepicker($('.js-datepicker'), $('#js-show-datepicker'))
      new Cake.Timepicker($('.js-timepicker'), $('#js-show-timepicker'))

      @$elem.find(".js-menu-modal-close").on('click', (e) ->
        targetId = $(e.target).data('menuid')
        window.history.pushState({ state: 'original', targetId: targetId }, null, Cake.Menus.originalUrl)
      )

      @$elem.find("#js-event-date-top").on('changeDate', (e) ->
      )

      @$elem.find("#js-event-time-top").on('changeTime.timepicker', (e) ->
        time = e.time.value
        $('#js-event-time').timepicker('setTime', time)
      )

      @$elem.find("#attendees-top").on('change', (e) ->
        #$("#js-event-time-top").timepicker('hideWidget')
        price = $('.price meta[itemprop="price"]').attr("content")
        nb = $( "#attendees-top option:selected" ).text()
        delivery = parseInt($('.delivery_cost[itemprop="deliveryCost"]').attr("content"))
        total = (nb*price) + delivery
        $("#price-button .price").text("$ " + total)

        $('#enquiry_event_attendees option').each ->
          @selected = @text == nb
          return
      )

      @$elem.find("#price-button").on('click', (e) ->
        $('#modal-content').scrollTop 0
      )

      elem = @$elem.find('.js-main-content')
      #@$elem.find('form').off('submit').on('submit', (e) ->
      #  e.preventDefault()
      #  form = $(this)
      #  $.post(form.attr('action'), form.serializeArray())
      #    .done((responseHtml) ->
      #      elem.html(responseHtml)
      #    )
      #    .fail(->
      #      elem.html("<p>Oh no, something went wrong! </p><p>Our developers have been notified - please close the popup and try again, or <a href='mailto:eat@youchews.com'>email us</a>.</p>")
      #    )
      #  elem.html("<div class='spinner'>&nbsp;</div>")
#
      #)


      @$elem.find('#js-has-dietary_reqs').on 'click', (e) ->
        $checkbox = $(e.target)
        if $checkbox.prop('checked')
          $('.js-show-dietary-reqs').show()
        else
          $('.js-show-dietary-reqs').hide()
#
#
      $('#js-edit-address').on 'click', ->
        $('.js-address-form').show()
        $('.js-address-text').hide()
#
      $('#js-add-address').on 'click', ->
        $("#js-address-#{field}").val('') for field in ['line-1', 'line-2', 'postcode', 'parking-information']
        $('#js-address-id').val('')
        $('.js-address-form').show()
        $('.js-address-text').hide()

      @setupForm()

      divwidth = $('.menu-dialog-image').width()
      $img = $('.menu-dialog-image img')
      $img.on 'load', ->
        imgwidth = $(this).width()
        if imgwidth > divwidth
          $img.addClass("big")

      judge.validate document.getElementById('js-address-line-1')

    )

  name: ->
    "enquiry"

  fieldsToValidate: ->
    fields = ['js-email', 'js-first-name', 'js-last-name']
