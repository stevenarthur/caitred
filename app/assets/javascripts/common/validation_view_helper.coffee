class Cake.ValidationViewHelper

  constructor: (fieldId, confirmationFieldId, validationMessage) ->
    @fieldId = fieldId
    @$fieldEl = $("##{fieldId}")
    @$confirmationEl = $("##{confirmationFieldId}") if confirmationFieldId
    @validationMessage = validationMessage

  @validate: (fieldId, helper, message) =>
    helper ||= new Cake.ValidationViewHelper(fieldId, undefined, message)
    deferred = $.Deferred()
    if helper.fieldPresent()
      helper.doJudgeValidation(deferred)
    else
      deferred.resolve()
    deferred

  fieldElement: ->
    _.first(@$fieldEl.get())

  fieldPresent: ->
    @$fieldEl.length > 0

  changed: ->
    @$fieldEl.val() == "" || @$fieldEl.val() != @_originalValue()

  _originalValue: ->
    $("##{@fieldId}-original").val()

  markValid: ->
    @_markField(@$fieldEl, 'has-success', 'has-error', 'glyphicon-ok', 'glyphicon-remove', "")
    if @$confirmationEl
      @_markField(@$confirmationEl, 'has-success', 'has-error', 'glyphicon-ok', 'glyphicon-remove', "")

  markAsError: (messages) ->
    @_markField(@$fieldEl, 'has-error', 'has-success', 'glyphicon-remove', 'glyphicon-ok', messages)
    if @$confirmationEl
      @_markField(@$confirmationEl, 'has-error', 'has-success', 'glyphicon-remove', 'glyphicon-ok', messages)

  getMessages: (messages) ->
    return @validationMessage unless _.isUndefined(@validationMessage)
    messages = _.map messages, (message) ->
      return message.replace(".", "") unless message.match "doesn't match Password"
      "doesn't match password confirmation"
    "#{@prefix()} #{messages.join(', ')}"

  prefix: ->
    return '' if @$fieldEl.data('excludefieldname')
    @getFieldName()

  getFieldName: ->
    @fieldId.split("-").join(" ").replace("js ", "")

  _markField: (field, addClass, removeClass, addIcon, removeIcon, html) ->
    field.closest('.js-field-group').addClass(addClass).removeClass(removeClass)
    if (field.siblings('.form-control-feedback').empty())
      field.closest('.js-field-group').find('.form-control-feedback').addClass(addIcon).removeClass(removeIcon)
      field.closest('.js-field-group').find('.js-errors').html(html)
    else
      field.siblings('.form-control-feedback').addClass(addIcon).removeClass(removeIcon)
      field.siblings('.js-errors').html(html)

  doJudgeValidation: (deferred) ->
    judge.validate @fieldElement(),
      valid: =>
        @markValid()
        deferred.resolve()
      invalid: (el, messages) =>
        messages = @getMessages(messages)
        @markAsError messages
        deferred.reject()
