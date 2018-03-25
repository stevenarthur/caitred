class Cake.EnquiryCalculator

  constructor: ->
    @attendees = 0
    @price = 0
    @delivery = 0
    @extras = []

  total: ->
    @subtotal() + @gst()

  subtotal: ->
    @foodTotal() + @extrasTotal() + @delivery

  foodTotal: ->
    @attendees * @price

  extrasTotal: ->
    attendees = @attendees
    _.reduce(@extras, (runningTotal, price) ->
      runningTotal + (price * attendees)
    , 0)

  gst: ->
    @subtotal() * 0.1

  addExtra: (price) ->
    @extras.push @_getFloat(price)

  clearExtras: ->
    @extras = []

  setAttendees: (attendees) ->
    @attendees = @_getInt(attendees)

  setPrice: (price) ->
    @price = @_getInt(price)

  setDelivery: (delivery) ->
    @delivery = @_getFloat(delivery)

  getAttendees: ->
    @attendees

  getPrice: ->
    @price

  getDelivery: ->
    @delivery

  _getInt: (val) ->
    if _.isNumber(val)
      val
    else
      parseInt(val) || 0

  _getFloat: (val) ->
    if _.isNumber(val)
      val
    else
      parseFloat(val) || 0
