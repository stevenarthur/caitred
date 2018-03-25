class Cake.EditDayFields

  @ready: ->
    new Cake.EditDayFields().setup()

  setup: ->
    $('form').on 'click', '.js--remove_day', (event) ->
      $(this).prev('input[type="hidden"]').val('1')
      $(this).closest('.row').hide()
      event.preventDefault()

    $('form').on 'click', '.js--add_fields', (event) ->
      time = new Date().getTime()
      regexp = new RegExp($(this).data('id'), 'g')
      $(this).parent().parent().before($(this).data('fields').replace(regexp, time))
      event.preventDefault()