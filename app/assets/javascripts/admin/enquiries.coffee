class Cake.Enquiries

  @ready: ->
    new Cake.EnquiryProgressor().setupEnquiryProgress()
    if $('#js-edit-enquiry').length > 0
      Cake.Enquiries.enquiryForm = new Cake.EnquiryForm($('#js-edit-enquiry'))

    $('.js-view-enquiry').click (e) ->
      Cake.popupLoaded = false
      url = $(e.target).closest('tr').data('remote')
      modalElem = $('#js-enquiry-modal')
      modalElem.load(url, ->
        modalElem.modal()
      )
      modalElem.on('shown.bs.modal', ->
        Cake.Enquiries.enquiryForm = new Cake.EnquiryForm(modalElem)
        Cake.popupLoaded = true
      )
      modalElem.on('hide.bs.modal', ->
        Cake.Enquiries.enquiryForm.destroyForm()
        modalElem.off('shown.bs.modal')
      )

    Sortable.init()
    $('.js-sort-headers').on 'click', (e) ->
      target = $(e.target)
      sortedAsc = target.hasClass('sorted-asc')
      sortedDesc = target.hasClass('sorted-desc')
      $('.js-sort-headers th').removeClass('sorted-asc').removeClass('sorted-desc')
      if sortedDesc
        target.addClass('sorted-asc')
      else
        target.addClass('sorted-desc')
