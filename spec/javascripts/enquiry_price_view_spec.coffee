describe 'EnquiryPriceView', ->
  beforeEach ->
    @$el = affix('#elem')
    @$attendees = affix('input.attendees')
    @$extras = affix('input.extras[type="checkbox"]')
    methods = ['total', 'getAttendees', 'getPrice', 'getDelivery', 'foodTotal', 'extrasTotal', 'setAttendees', 'clearExtras', 'addExtra', 'subtotal', 'gst']
    @calculator = jasmine.createSpyObj('calculator', methods)
    @calculator.total.and.returnValue(10)
    @calculator.getAttendees.and.returnValue(8)
    @calculator.getPrice.and.returnValue(7)
    @calculator.getDelivery.and.returnValue(25)
    @calculator.foodTotal.and.returnValue(140)
    @calculator.extrasTotal.and.returnValue(50.5)
    @calculator.subtotal.and.returnValue(60)
    @calculator.gst.and.returnValue(12.5)
    @price_view = new Cake.EnquiryPriceView(@$el, @calculator, @$attendees, @$extras)
    @price_view.render()

  it 'renders the template', ->
    expect(@$el.find(".js-cost-info").length).toEqual 1

  it 'renders the food cost', ->
    expect(@$el.find('.js-food-cost')).toHaveContent('$140')

  it 'renders the menu cost', ->
    expect(@$el.find('.js-menu-cost')).toHaveContent(' $7 ')

  it 'renders the attendees', ->
    expect(@$el.find('.js-attendees')).toHaveContent(' 8 ')

  it 'renders the extras cost', ->
    expect(@$el.find('.js-extras-cost')).toHaveContent('$50.50')

  it 'renders the delivery cost', ->
    expect(@$el.find('.js-delivery-cost')).toHaveContent('$25')

  it 'renders the subtotal cost', ->
    expect(@$el.find('.js-sub-total-cost')).toHaveContent('$60')

  it 'renders the total cost', ->
    expect(@$el.find('.js-total-cost')).toHaveContent('$10')

  it 'renders the gst cost', ->
    expect(@$el.find('.js-gst-cost')).toHaveContent('$12.50')

  it 'updates the attendees when the field value changes', ->
    @$attendees.val(50).blur()
    expect(@calculator.setAttendees).toHaveBeenCalled()

  it 'updates extras when extras change', ->
    @$extras.prop(checked: true)
    @$extras.change()
    expect(@calculator.clearExtras).toHaveBeenCalled()
    expect(@calculator.addExtra).toHaveBeenCalled()



