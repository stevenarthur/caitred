class Cake.Sticky
  @ready: ->
    setTimeout -> 
      $('.js--sticky-menu').stick_in_parent({ offset_top: 100 })
      $('.js--sticky-order').stick_in_parent({ offset_top: 30 })
    , 10
