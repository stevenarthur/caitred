$ ->
  validateRegistrationForm = ->
    form = $('form#new_customer')
    inputsToValidate = $(form).find('input[data-validate]')

    # Clear past form states
    form.find('.form-group').removeClass('has-error')
    form.find('.help-block--error').remove()

    _.each inputsToValidate, (value, index, list) ->
       
      # Validate each input
      judge.validate(document.getElementById(value.id), {
        valid: (element) ->
          $(element).closest('.form-group').removeClass('has-error')
        invalid: (element, messages) ->
          $('form#new_customer').addClass('form--has-error')

          formGroup = $(element).closest('.form-group')
          formGroup.addClass('has-error')

          # Add messages to input
          formGroup.append("<p class='help-block help-block--error'>" + messages[0] + "</p>")
      })

  $('form#new_customer').on 'submit', (e) ->
    e.preventDefault()
    form = $('form#new_customer')
    validateRegistrationForm()

    if (form.find('.form-group.has-error').length == 0)
      form.get(0).submit()

    return false
