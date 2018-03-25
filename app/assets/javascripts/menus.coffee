Cake.Menus = implementing Cake.JudgeForm, class Cake._Menus

  @ready: ->
    $('.js-tooltip').tooltip()
    Cake.Menus.originalTitle = "Catering Menus for Corporate Events - Caitre'd"
    Cake.Menus.originalUrl ||= '/catering/sydney'
    menuFilterClass = Cake.Store.get('menu.filters', 'collapsed')
    $('#js-extra-menu-filters').addClass(menuFilterClass)
    $('#js-filter-button').addClass(menuFilterClass)

    #$('.popstart').on('click', (e) ->
    #  alert('click')
    #  url = "/catering/sydney/menu/handmade-partner-doughnuts"
    #  popup = new Cake.EnquiryPopup($('#js-enquiry-modal'), url, $('#js-attendees'), '2200').show()
    #)

    DisableBeforeToday = (date) ->
      if date < new Date
        [ false ]
      else
        [ true ]

    $('.js-datepicker').datepicker({
      dateFormat: 'dd M yy',
      firstDay: 1,
      beforeShowDay: DisableBeforeToday,
     })

    $('[data-toggle="tooltip"]').tooltip()

    $('.js-menu-info').on('click', (e) ->
      e.preventDefault()
      target = $(e.target) #$('.menu-image').target
      url = "/catering/sydney/menu/#{target.data('slug')}"
      targetId = target.data('menuid')
      window.history.replaceState({ state: 'original', targetId: targetId }, null, Cake.Menus.originalUrl)
      window.history.pushState({ state: 'modal', targetId: targetId }, null, url)
      popupUrl = target.data('remote')
      postcode = $('#postcode').val()
      popup = new Cake.EnquiryPopup($('#js-enquiry-modal'), popupUrl, $('#js-attendees'), postcode).show()
      Cake.Analytics.trackMenuView(popupUrl)
    )

    $(".js-menu-modal").on('show.bs.modal', (e) ->
      title = $(e.target).data('menutitle')
      document.title = "#{title} - Caitre'd"
    )
    $('.js-menu-modal').on('hide.bs.modal', ->
      document.title = Cake.Menus.originalTitle
    )

    $('.js-menu-select').on('click', (e) ->
      url = $(e.target).data('remote')
      popup = new Cake.EnquiryPopup($('#js-enquiry-modal'), url, $('#js-attendees')).show()
      Cake.Analytics.trackMenuView(url)
    )

    $("#js-event-time-top").on('changeTime.timepicker', (e) ->
        time = e.time.value
        $('#js-event-time').timepicker('setTime', time)
    )

    $("#attendees-top").on('change', (e) ->
        $("#js-event-time-top").timepicker('hideWidget')
        price = $('.price meta[itemprop="price"]').attr("content")
        nb = $( "#attendees-top option:selected" ).text()
        delivery = parseInt($('.delivery_cost[itemprop="deliveryCost"]').attr("content"))
        total = (nb*price) + delivery
        $("#price-button-enquiry .price").text("$ " + total)

        $('#enquiry_event_attendees option').each ->
          @selected = @text == nb
          return
    )

    $('#js-show-filters').on('click', (e) ->
      e.preventDefault()
      $('#js-extra-menu-filters').addClass('expanded').removeClass('collapsed')
      $('#js-filter-button').addClass('expanded').removeClass('collapsed')
      Cake.Store.set('menu.filters', 'expanded')
    )

    $('#js-hide-filters').on('click', (e) ->
      e.preventDefault()
      $('#js-extra-menu-filters').addClass('collapsed').removeClass('expanded')
      $('#js-filter-button').addClass('collapsed').removeClass('expanded')
      Cake.Store.set('menu.filters', 'collapsed')
    )

    $(window).on("popstate", (e) ->
      state = e.originalEvent.state
      return if _.isNull(state)
      if state.state == 'modal'
        $("#js-menu-modal-#{state.targetId}").modal('show')
      else
        $("#js-menu-modal-#{state.targetId}").modal('hide')
    )
    unless _.isUndefined(window.showMenu)
      url = window.showMenu
      popup = new Cake.EnquiryPopup($('#js-enquiry-modal'), url, $('#js-attendees')).show()

    Cake.Menus.menuForm = menuForm = new Cake.Menus()
    menuForm.setupForm()


    $("#price-button-enquiry").click ->
      $(".new-enquiry").trigger("click")



  name: ->
    "menus"

  fieldsToValidate: ->
    fields = ['js-attendees']
