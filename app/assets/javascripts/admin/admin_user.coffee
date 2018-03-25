class Cake.AdminUser

  @ready: ->
    $('.js-judge-validate').on('click', (e) ->
      e.preventDefault()
      adminUser = new Cake.AdminUser()
      adminUser.validateAllFields()
    )

  validateAllFields: ->
    alwaysValidate = _.map ['js-first-name', 'js-last-name', 'js-mobile-number'], (field) =>
      @validate(field)

    validateWithConfirmation = [@validateWithConfirmationField('js-password')]

    validateOnChange = _.map ['js-username', 'js-email'], (field) =>
      @validateOnlyIfChanged(field)

    deferreds = alwaysValidate.concat(validateOnChange).concat(validateWithConfirmation)

    $.when.apply(this, deferreds).done  (=>
      $('.js-judge-validate-form').submit()
    )

  isValid: -> 
    $('.js-judge-validate-form .has-error').length == 0

  validateOnlyIfChanged: (fieldId) ->
    helper = new Cake.ValidationViewHelper(fieldId)
    if helper.changed()
      @validate(fieldId, helper) 
    else
      helper.markValid()
      $.Deferred().resolve()

  validateWithConfirmationField: (fieldId) ->
    helper = new Cake.ValidationViewHelper(fieldId, "#{fieldId}_confirmation")
    @validate(fieldId, helper)
    
  # todo: replace with validationviewhelper method
  validate: (fieldId, helper) -> 
    helper ||= new Cake.ValidationViewHelper(fieldId)
    deferred = $.Deferred()
    if helper.fieldPresent()
      @_doJudgeValidation(helper, deferred)
    else 
      deferred.resolve()
    deferred

    # todo: replace with validationviewhelper method
  _doJudgeValidation: (helper, deferred) ->
    judge.validate helper.fieldElement(),
      valid: ->
        helper.markValid()
        deferred.resolve()
      invalid: (el, messages) ->
        messages = helper.getMessages messages
        helper.markAsError messages
        deferred.reject()

  getFieldName: (fieldId) ->
    fieldId.split("-").join(" ").replace("js ", "")

