$ ->
  validateNewOrderFormSection=(section) ->
    form = $(section)
    inputsToValidate = $(form).find('input[data-validate], 
                                     textarea[data-validate], 
                                     select[data-validate]')
    # Clear past form states
    form.find('.form-group').removeClass('has-error')
    form.find('.help-block--error').remove()

    _.each inputsToValidate, (value, index, list) ->
       
      # Validate each input
      judge.validate(document.getElementById(value.id), {
        valid: (element) ->
          $(element).closest('.form-group').removeClass('has-error')
        invalid: (element, messages) ->
          $('form#js--new-order').addClass('form--has-error')

          formGroup = $(element).closest('.form-group')
          formGroup.addClass('has-error')

          # Add messages to input
          formGroup.append("<p class='help-block help-block--error'>" + messages[0] + "</p>")
      })

  hideFieldset=(fieldset) ->
    $('.fieldset-wrap fieldset').removeClass('active')
    $(fieldset).addClass('active')

  current_step = 1

  $('.js--fieldset-delivery-header').on 'click', (e) ->
    if current_step != 1
      current_step = 1
      hideFieldset('.js--fieldset-delivery')

  $('.js--fieldset-personal-header').on 'click', (e) ->
    if current_step > 2
      current_step = 2
      hideFieldset('.js--fieldset-personal')

  $('#qa--cont-to-personal').on 'click', (e) ->
    e.preventDefault()
    validateNewOrderFormSection($('.js--fieldset-delivery'))
    if ($('.form-group.has-error').length == 0)
      current_step = 2
      $('.js--fieldset-delivery').removeClass('active')
      $('.js--fieldset-personal').addClass('active')

    return false

  $('#qa--cont-to-payment').on 'click', (e) ->
    e.preventDefault()
    validateNewOrderFormSection($('.js--fieldset-personal'))
    if ($('.form-group.has-error').length == 0)
      current_step = 3
      $('.js--fieldset-personal').removeClass('active')
      $('.js--fieldset-payment').addClass('active')

    return false

  form = $('form#js--new-order')
  $(form).on 'submit', (e) ->
    e.preventDefault()
    form = $('form#js--new-order')
    validateNewOrderFormSection(form)

    if ($('.form-group.has-error').length == 0)
      form.get(0).submit()

    return false
