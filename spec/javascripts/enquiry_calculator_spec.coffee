describe 'EnquiryCalculator', ->

  describe 'calculation of pricing', ->
    beforeEach ->
      @calculator = new Cake.EnquiryCalculator()

    describe 'calculating food cost', ->

      it 'is 0 if nothing is set', ->
        expect(@calculator.foodTotal()).toEqual 0

      it 'is 0 if there are no attendees', ->
        @calculator.setAttendees(0)
        expect(@calculator.foodTotal()).toEqual 0

      it 'is 0 if there are attendees but price is 0', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(0)
        expect(@calculator.foodTotal()).toEqual 0

      it 'calculates the total from price and attendees', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        expect(@calculator.foodTotal()).toEqual 200

      it 'does not include delivery', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        @calculator.setDelivery(10)
        expect(@calculator.foodTotal()).toEqual 200

    describe 'calculating extras', ->

      it 'is 0 if nothing is set', ->
        expect(@calculator.extrasTotal()).toEqual 0

      it 'is 0 if there are no attendees', ->
        @calculator.setAttendees(0)
        expect(@calculator.extrasTotal()).toEqual 0

      it 'is 0 if there are attendees but no extras', ->
        @calculator.setAttendees(50)
        expect(@calculator.extrasTotal()).toEqual 0

      it 'is 0 if there are attendees but all extras are free', ->
        @calculator.setAttendees(50)
        @calculator.addExtra(0)
        expect(@calculator.extrasTotal()).toEqual 0

      it 'adds the cost per attendee for a single extra', ->
        @calculator.setAttendees(50)
        @calculator.addExtra(10)
        expect(@calculator.extrasTotal()).toEqual 500

      it 'adds the cost per extra for multiple extras', ->
        @calculator.setAttendees(50)
        @calculator.addExtra(10)
        @calculator.addExtra(5)
        expect(@calculator.extrasTotal()).toEqual 750

      it 'clears the extras', ->
        @calculator.setAttendees(50)
        @calculator.addExtra(10)
        @calculator.addExtra(5)
        @calculator.clearExtras()
        expect(@calculator.extrasTotal()).toEqual 0

      it 'accepts a float for an extra', ->
        @calculator.setAttendees(50)
        @calculator.addExtra(10)
        expect(@calculator.extrasTotal()).toEqual 500

    describe 'calculating GST', ->

      it 'is 0 if nothing is set', ->
        expect(@calculator.gst()).toEqual 0

      it 'is 0 if there are no attendees and no extras', ->
        @calculator.setAttendees(0)
        expect(@calculator.gst()).toEqual 0

      it 'is 0 if there are attendees but price is 0', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(0)
        expect(@calculator.gst()).toEqual 0

      it 'calculates from the total for from price and attendees', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        expect(@calculator.gst()).toEqual 20

      it 'includes gst on the delivery cost', ->
        @calculator.setAttendees(2)
        @calculator.setPrice(40)
        @calculator.setDelivery(10)
        expect(@calculator.gst()).toEqual 9

      it 'adds the extras cost', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        @calculator.addExtra(10)
        expect(@calculator.gst()).toEqual 30

    describe 'calculating subtotal', ->

      it 'is 0 if nothing is set', ->
        expect(@calculator.subtotal()).toEqual 0

      it 'is 0 if there are no attendees and no extras', ->
        @calculator.setAttendees(0)
        expect(@calculator.subtotal()).toEqual 0

      it 'is 0 if there are attendees but price is 0', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(0)
        expect(@calculator.subtotal()).toEqual 0

      it 'calculates the subtotal from price and attendees', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        expect(@calculator.subtotal()).toEqual 200

      it 'adds the delivery cost', ->
        @calculator.setAttendees(2)
        @calculator.setPrice(40)
        @calculator.setDelivery(10)
        expect(@calculator.subtotal()).toEqual 90

      it 'adds the extras cost', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        @calculator.addExtra(10)
        expect(@calculator.subtotal()).toEqual 300

    describe 'calculating total', ->

      it 'is 0 if nothing is set', ->
        expect(@calculator.total()).toEqual 0

      it 'is 0 if there are no attendees and no extras', ->
        @calculator.setAttendees(0)
        expect(@calculator.total()).toEqual 0

      it 'is 0 if there are attendees but price is 0', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(0)
        expect(@calculator.total()).toEqual 0

      it 'calculates the total from price and attendees plus gst', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        expect(@calculator.total()).toEqual 220

      it 'adds the delivery cost plus gst', ->
        @calculator.setAttendees(2)
        @calculator.setPrice(40)
        @calculator.setDelivery(10)
        expect(@calculator.total()).toEqual 99

      it 'adds the extras cost plus gst', ->
        @calculator.setAttendees(10)
        @calculator.setPrice(20)
        @calculator.addExtra(10)
        expect(@calculator.total()).toEqual 330

    describe 'accepting strings', ->

      it 'accepts a string with a number for attendees', ->
        @calculator.setAttendees('5')
        @calculator.setPrice(10)
        expect(@calculator.subtotal()).toEqual 50

      it 'accepts a string with a number for price', ->
        @calculator.setAttendees(2)
        @calculator.setPrice('50')
        expect(@calculator.subtotal()).toEqual 100

      it 'accepts a string for delivery', ->
        @calculator.setAttendees(2)
        @calculator.setPrice(40)
        @calculator.setDelivery('15')
        expect(@calculator.subtotal()).toEqual 95

      it 'accepts a string for extra price', ->
        @calculator.setAttendees(50)
        @calculator.addExtra('5.3')
        expect(@calculator.extrasTotal()).toEqual 265

    describe 'error handling', ->

      it 'is 0 if attendees is not a number', ->
        @calculator.setAttendees('hello!')
        @calculator.setPrice(10)
        expect(@calculator.total()).toEqual 0

      it 'is 0 if attendees is not a number', ->
        @calculator.setAttendees(50)
        @calculator.setPrice('wtf')
        expect(@calculator.total()).toEqual 0

      it 'adds 0 for delivery plus gst if it is not a number', ->
        @calculator.setAttendees(3)
        @calculator.setPrice(40)
        @calculator.setDelivery('not the mama')
        expect(@calculator.total()).toEqual 132

      it 'sets 0 for extra price if it is not a float', ->
        @calculator.setAttendees(50)
        @calculator.addExtra('blah')
        expect(@calculator.extrasTotal()).toEqual 0

    describe 'accessing properties', ->

      it 'allows access to attendees', ->
        @calculator.setAttendees(3)
        expect(@calculator.getAttendees()).toEqual(3)

      it 'allows access to the menu price', ->
        @calculator.setPrice(10)
        expect(@calculator.getPrice()).toEqual(10)

      it 'allows access to the delivery price', ->
        @calculator.setDelivery(25)
        expect(@calculator.getDelivery()).toEqual(25)
