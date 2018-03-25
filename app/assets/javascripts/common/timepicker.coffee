class Cake.Timepicker

  constructor: ($element, $trigger) ->
    $element.timepicker(
      defaultTime: '1:00 PM'
      )
    $element.on 'click', ->
      $element.timepicker('showWidget')
    $($trigger).on 'click', ->
      $element.timepicker('showWidget')

  destroy: ->
    $('.bootstrap-timepicker-widget').remove()
