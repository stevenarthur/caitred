class Cake.Reviews

  @ready: ->
    new Cake.Reviews().setup()

  setup: ->
    field = $('#js-rating-field')
    form = $('#js-rating-form')
    $('.js-review-choice').on 'click', (e) ->
      target = $(e.target).closest('a')
      field.val(target.data('rating'))
      form.submit()

