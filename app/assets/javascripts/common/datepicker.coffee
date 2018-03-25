class Cake.Datepicker

  constructor: (@$element, @$trigger) ->
    @$element.datepicker(
      language: 'en',
      dateFormat: "dd M yy"
      ).on 'changeDate', =>
        @$element.datepicker('hide')
    $(@$trigger).on 'click', =>
      @$element.datepicker('show')


  destroy: ->
    $('.datepicker').remove()
