#= require support/spec-helper

describe 'AdminUser', ->

  beforeEach ->
    @deferred = $.Deferred()
    @adminUser = new Cake.AdminUser()
    @helper = jasmine.createSpyObj 'helper', ['fieldElement', 'markValid', 'markAsError', 'getMessages', 'changed', 'fieldPresent']
    @helper.fieldElement.and.returnValue "fieldElement"
    @helper.getMessages.and.returnValue "messages"
    @helper.fieldPresent.and.returnValue true
    spyOn(Cake, "ValidationViewHelper").and.returnValue @helper
    spyOn judge, "validate"
    spyOn $.fn, 'submit'

  describe 'Validation', ->

    it 'is valid if there are no error messages', ->
      expect(@adminUser.isValid()).toBeTruthy()

    it 'is not valid if there are error messages', ->
      affix('.js-judge-validate-form .has-error')
      expect(@adminUser.isValid()).toBeFalsy()

  describe 'judge validation', ->

    it 'calls the judge validate method', ->
      @adminUser._doJudgeValidation(@helper, @deferred)
      expect(judge.validate).toHaveBeenCalledWith("fieldElement", jasmine.any(Object))

    describe 'valid input', ->

      beforeEach ->
        judge.validate.and.callFake((field, callbacks) -> callbacks.valid())
        @adminUser._doJudgeValidation(@helper, @deferred)

      it 'resolves the deferred', ->
        expect(@deferred.state()).toEqual "resolved"

      it 'marks the input valid', ->
        expect(@helper.markValid).toHaveBeenCalled()

    describe 'invalid input', ->

      beforeEach ->
        judge.validate.and.callFake((field, callbacks) -> callbacks.invalid())
        @adminUser._doJudgeValidation(@helper, @deferred)

      it 'fails the deferred', ->
        expect(@deferred.state()).toEqual "rejected"

      it 'marks the input invalid', ->
        expect(@helper.markAsError).toHaveBeenCalled()

  describe 'validation of a single field', ->

    it 'returns a deferred object', ->
      expect(@adminUser.validate('field').state()).toBe "pending"

    it 'calls through to judge validate with the correct field', ->
      @adminUser.validate('field')
      expect(judge.validate).toHaveBeenCalledWith 'fieldElement', jasmine.any(Object)

    describe 'field not present', ->
      beforeEach ->
        @helper.fieldPresent.and.returnValue false
        @adminUser.validate('field')

      it 'does not call the validate method', ->
        expect(judge.validate).not.toHaveBeenCalled()

  describe 'validation only if changed', ->

    describe 'field has not changed', ->

      beforeEach ->
        @helper.changed.and.returnValue false
        @adminUser.validateOnlyIfChanged('field')

      it 'does not validate', ->
        expect(judge.validate).not.toHaveBeenCalled()

      it 'returns a resolved deferred object', ->
        expect(@adminUser.validateOnlyIfChanged('field').state()).toBe "resolved"

    describe 'when field changed', ->

      beforeEach ->
        @helper.changed.and.returnValue true
        @adminUser.validateOnlyIfChanged('field')

      it 'validates the field', ->
        expect(judge.validate).toHaveBeenCalled()

      it 'returns a deferred object', ->
       expect(@adminUser.validateOnlyIfChanged('field').state()).toBe "pending"

  describe 'validation of all fields', ->

    describe 'all valid', ->

      beforeEach ->
        judge.validate.and.callFake((field, callbacks) -> callbacks.valid())
        @adminUser.validateAllFields()

      it 'validates first name', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-first-name'

      it 'validates last name', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-last-name'

      it 'validates username', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-username'

      it 'validates mobile', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-mobile-number'

      it 'validates email', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-email'

      it 'validates password and confirmation field', ->
        expect(Cake.ValidationViewHelper).toHaveBeenCalledWith 'js-password', 'js-password_confirmation'

      it 'submits the form if all deferreds pass', ->
        expect($.fn.submit).toHaveBeenCalled()

    describe 'all failures', ->

      beforeEach ->
        judge.validate.and.callFake((field, callbacks) -> callbacks.invalid())
        @adminUser.validateAllFields()

      it 'does not submit the form if all deferreds fail', ->
        expect($.fn.submit).not.toHaveBeenCalled()


