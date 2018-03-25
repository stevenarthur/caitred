class Cake.Addresses

  @ready: ->
    new Cake.Addresses().setupLinks()

  setupLinks: =>
    @setupAddAddress()
    @setupEditAddress()
    @setupDefaultAddress()
    @setupAddressSelect()
    @setupSaveAddress()

  setupAddAddress: ->
    setupLinks = @setupLinks
    $('.js-add-address').on 'click', (e) ->
      url = $(e.target).data('href')
      $.ajax(url).done (html) ->
        $('.js-address-details').html(html)
        setupLinks()

  setupEditAddress: ->
    setupLinks = @setupLinks
    $('.js-edit-address').on 'click', (e) ->
      url = $(e.target).data('href')
      $.ajax(url).done (html) ->
        $('.js-address-details').html(html)
        setupLinks()

  setupDefaultAddress: ->
    setupLinks = @setupLinks
    $('.js-set-address-default').on 'click', (e) ->
      url = $(e.target).data('href')
      $.post(url).done (html) ->
        successMsg = $('<div />').addClass('alert alert-success').text('Address set as default')
        $('.js-enquiry-title').parent().append(successMsg)

  setupAddressSelect: ->
    reloadFn = @reloadHtml
    $('#js-choose-address').on 'change', (e) ->
      target = $(e.target)
      url = target.data('href')
      data = { address_id: target.val() }
      $.post(url, data).done ->
        reloadFn()

  setupSaveAddress: ->
    reloadFn = @reloadHtml
    $('#js-save-address').on 'click', (e) ->
      e.preventDefault();
      form = $(e.target).closest('form')
      url = form.attr('action')
      data = form.serializeArray()
      $.post(url, data)
        .done (data) ->
          if data
            $.post(enquirySetAddressUrl, { address_id: data.address_id }).done ->
              reloadFn()
          else
            reloadFn()

  reloadHtml: () =>
    $.ajax(enquiryAddressUrl).done (html) =>
      $('.js-address-details').html(html)
      @setupLinks()
