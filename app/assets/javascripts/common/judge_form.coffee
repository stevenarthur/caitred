class Cake.JudgeForm

  setupForm: ->
    $(".js-judge-validate-#{@name()}").on('click', (e) =>
      e.preventDefault()
      @validateAllFields()
      $(document).trigger(Cake.Events.VALIDATION_COMPLETE)
    )

  destroyForm: ->
    $(".js-judge-validate-#{@name()}").off('click')

  validateAllFields: =>
    message = @getMessage() unless _.isUndefined(@getMessage)
    alwaysValidate = _.map(@fieldsToValidate(), (field) =>
      Cake.ValidationViewHelper.validate(field, null, message)
    )
    $.when.apply(this, alwaysValidate).done  (=>
      $(".js-judge-validate-#{@name()}-form").submit()
    )
