Cake.ResetPassword = implementing Cake.JudgeForm, class Cake._ResetPassword

  @ready: ->
    Cake.ResetPassword.resetForm = resetForm = new Cake.ResetPassword()
    resetForm.setupForm()

  name: ->
    "reset-password"

  fieldsToValidate: ->
    fields = ['js-password', 'js-password-confirmation']
