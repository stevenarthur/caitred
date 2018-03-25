class Cake.EnquiryPriceView

  constructor: ($el, calculator, $attendeesEl, $extrasEls) ->
    @$el = $el
    @calculator = calculator
    @extras = []
    $attendeesEl.on 'blur', (e) =>
      @_recalculateAttendees(e)
    @$extrasEls = $extrasEls
    @$extrasEls.on 'change', (e) =>
      @_recalculateExtras(e)

  template: ->
    Cake.Templates.EnquiryPriceView

  extraTemplate: ->
    Cake.Templates.ExtraLineView

  render: ->
    @$el.html(@template()(@_params()))

  _params: ->
    params = Cake.EnquiryPriceViewHelper.priceViewParams(@calculator)
    params.extras = @extras
    params

  _recalculateAttendees: (e) ->
    @calculator.setAttendees($(e.target).val())
    @render()

  _recalculateExtras: (e) ->
    @calculator.clearExtras()
    @extras = []
    @$extrasEls.each (index, elem) =>
      checkbox = $(elem)
      if checkbox.is(":checked")
        @_addExtra(checkbox)
    @render()

  _addExtra: (checkbox) ->
    price = checkbox.data("price")
    @extras.push {
      price: price
      title: checkbox.data("title")
    }
    @calculator.addExtra(price)
