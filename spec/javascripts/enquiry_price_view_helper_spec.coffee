describe 'EnquiryPriceViewHelper', ->
  beforeEach ->
    @calculator = jasmine.createSpyObj('calculator', ['total', 'getAttendees', 'getPrice', 'getDelivery', 'foodTotal', 'extrasTotal', 'gst', 'subtotal'])
    @calculator.total.and.returnValue(10)
    @calculator.getAttendees.and.returnValue(8)
    @calculator.getPrice.and.returnValue(7)
    @calculator.getDelivery.and.returnValue(25)
    @calculator.foodTotal.and.returnValue(140)
    @calculator.extrasTotal.and.returnValue(50.5)
    @calculator.gst.and.returnValue(45)
    @calculator.subtotal.and.returnValue(250)
    @params = Cake.EnquiryPriceViewHelper.priceViewParams(@calculator)

  it 'contains a formatted total price', ->
    expect(@params.totalCost).toEqual('$10')

  it 'contains the number of attendees', ->
    expect(@params.attendees).toEqual(8)

  it 'contains the formatted extras total', ->
    expect(@params.extrasCost).toEqual('$50.50')

  it 'contains the delivery cost', ->
    expect(@params.deliveryCost).toEqual('$25')

  it 'contains the menu cost', ->
    expect(@params.menuCost).toEqual('$7')

  it 'contains the food cost', ->
    expect(@params.foodCost).toEqual('$140')

  it 'contains the gst', ->
    expect(@params.gstCost).toEqual('$45')

  it 'contains the subtotal cost', ->
    expect(@params.subtotalCost).toEqual('$250')
