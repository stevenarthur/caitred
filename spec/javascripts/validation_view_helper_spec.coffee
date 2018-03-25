describe 'ValidationViewHelper', ->

  describe 'fieldElement', ->

    it 'returns the dom element', ->
      field = affix('#field')
      helper = new Cake.ValidationViewHelper("field")
      expect(helper.fieldElement().id).toEqual "field"

  describe 'markValid', ->

    beforeEach ->
      @container = affix('.js-field-group.has-error')
      @feedback = @container.affix('.form-control-feedback.glyphicon-remove')
      @errors = @container.affix('.js-errors')
      @field = @container.affix('#field')
      @helper = new Cake.ValidationViewHelper("field")
      @helper.markValid()

    it 'marks the field group as having success', ->
      expect(@container).toHaveCssClass('has-success')

    it 'removes the errors class from the field group', ->
      expect(@container).not.toHaveCssClass('has-error')

    it 'ensures the feedback element has the OK icon', ->
      expect(@feedback).toHaveCssClass('glyphicon-ok')

    it 'ensures the feedback element does not have the error icon', ->
      expect(@feedback).not.toHaveCssClass('glyphicon-remove')

    it 'blanks the errors element', ->
      expect(@errors).toHaveNoContent()

  describe 'markValid with confirmation field', ->

    beforeEach ->
      @container = affix('.js-field-group.has-error')
      @feedback = @container.affix('.form-control-feedback.glyphicon-remove')
      @errors = @container.affix('.js-errors')
      @field = @container.affix('#field')

      @confirmationContainer = affix('.js-field-group.has-error')
      @confirmationField = @confirmationContainer.affix('#field-confirmation')
      @confirmationFeedback = @confirmationContainer.affix('.form-control-feedback.glyphicon-remove')
      @confirmationErrors = @container.affix('.js-errors')

      @helper = new Cake.ValidationViewHelper("field", "field-confirmation")
      @helper.markValid()

    it 'marks the field group as having success', ->
      expect(@confirmationContainer).toHaveCssClass('has-success')

    it 'removes the errors class from the field group', ->
      expect(@confirmationContainer).not.toHaveCssClass('has-error')

    it 'ensures the feedback element has the OK icon', ->
      expect(@confirmationFeedback).toHaveCssClass('glyphicon-ok')

    it 'ensures the feedback element does not have the error icon', ->
      expect(@confirmationFeedback).not.toHaveCssClass('glyphicon-remove')

    it 'blanks the errors element', ->
      expect(@confirmationErrors).toHaveNoContent()

  describe 'markAsError', ->

    beforeEach ->
      @container = affix('.js-field-group.has-success')
      @feedback = @container.affix('.form-control-feedback.glyphicon-ok')
      @errors = @container.affix('.js-errors')
      @field = @container.affix('#field')
      @errorMessage = "This is wrong"
      @helper = new Cake.ValidationViewHelper("field")
      @helper.markAsError(@errorMessage)

    it 'marks the field group as having an error', ->
      expect(@container).toHaveCssClass('has-error')

    it 'removes the success class from the field group', ->
      expect(@container).not.toHaveCssClass('has-success')

    it 'ensures the feedback element has the error icon', ->
      expect(@feedback).toHaveCssClass('glyphicon-remove')

    it 'ensures the feedback element does not have the OK icon', ->
      expect(@feedback).not.toHaveCssClass('glyphicon-ok')

    it 'puts the errors html into the errors element', ->
      expect(@errors).toHaveContent(@errorMessage)

  describe 'markAsError with confirmation field', ->

    beforeEach ->
      @container = affix('.js-field-group.has-success')
      @feedback = @container.affix('.form-control-feedback.glyphicon-ok')
      @errors = @container.affix('.js-errors')
      @field = @container.affix('#field')

      @confirmationContainer = affix('.js-field-group.has-success')
      @confirmationField = @confirmationContainer.affix('#field-confirmation')
      @confirmationFeedback = @confirmationContainer.affix('.form-control-feedback.glyphicon-ok')
      @confirmationErrors = @container.affix('.js-errors')

      @errorMessage = "This is wrong"
      @helper = new Cake.ValidationViewHelper("field", "field-confirmation")
      @helper.markAsError(@errorMessage)

    it 'marks the field group as having an error', ->
      expect(@confirmationContainer).toHaveCssClass('has-error')

    it 'removes the success class from the field group', ->
      expect(@confirmationContainer).not.toHaveCssClass('has-success')

    it 'ensures the feedback element has the error icon', ->
      expect(@confirmationFeedback).toHaveCssClass('glyphicon-remove')

    it 'ensures the feedback element does not have the OK icon', ->
      expect(@confirmationFeedback).not.toHaveCssClass('glyphicon-ok')

    it 'puts the errors html into the errors element', ->
      expect(@errors).toHaveContent(@errorMessage)

  describe 'getMessages', ->

    beforeEach ->
      @messages = ['something wrong.', 'another thing wrong.', "something doesn't match Password"]
      @field = affix('#js-field-name')
      @helper = new Cake.ValidationViewHelper('js-field-name')
      @result = @helper.getMessages(@messages)

    it 'joins the messages from judge together', ->
      expect(@result).toContain 'something wrong'
      expect(@result).toContain 'another thing wrong'

    it 'removes full stops', ->
      expect(@result).toContain 'something wrong, another thing wrong'

    it 'adds the field name', ->
      expect(@result).toContain 'field name'

    it 'makes the password confirmation message sound more sensible', ->
      expect(@result).toContain "doesn't match password confirmation"

  describe 'getFieldName', ->

    beforeEach ->
      @helper = new Cake.ValidationViewHelper('js-field-name')

    it 'removes the js and dash to create a normal field name', ->
      expect(@helper.getFieldName('js-field-name')).toEqual 'field name'

  describe 'value changing', ->

    beforeEach ->
      @field = affix('input#js-field-name')
      @field.val('original value')
      @originalField = affix('input#js-field-name-original')
      @originalField.val('original value')
      @helper = new Cake.ValidationViewHelper('js-field-name')

    it 'has changed if values are different', ->
      @field.val('current value')
      expect(@helper.changed()).toBeTruthy()

    it 'has not changed if values are the same', ->
      expect(@helper.changed()).toBeFalsy()

    it 'has changed if the value is blank', ->
      @field.val('')
      @originalField.val('')
      expect(@helper.changed()).toBeTruthy()

  describe 'field not present', ->

    beforeEach ->
      @helper = new Cake.ValidationViewHelper("js-field-name")

    it 'returns false for present', ->
      expect(@helper.fieldPresent()).toEqual false

  describe 'field present', ->

    beforeEach ->
      @field = affix('#js-field-name')
      @helper = new Cake.ValidationViewHelper("js-field-name")

    it 'returns false for present', ->
      expect(@helper.fieldPresent()).toEqual true
