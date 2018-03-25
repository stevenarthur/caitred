Cake.FoodPartners = implementing Cake.JudgeForm, class Cake._FoodPartners

  @ready: ->
    $('.js-send-email').click((e)->
      e.preventDefault()
      $(this).closest('form').submit()
      )

    $('.js-preview').click((e)->
      e.preventDefault()
      )

    $("#js-nav a[href='#{window.location.hash}']").tab('show')

    Cake.FoodPartners.FoodPartner = FoodPartner = new Cake.FoodPartners()
    FoodPartner.setupForm()

  name: ->
    "food-partner"

  fieldsToValidate: ->
   ['js-min-spend', 'js-min-attendees', 'js-max-attendees', 'js-delivery-cost']
