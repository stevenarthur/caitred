class Cake.EnquiryPriceViewHelper

  @priceViewParams: (calculator) ->
    {
      totalCost: "$#{Cake.Formatters.price(calculator.total())}",
      attendees: calculator.getAttendees(),
      extrasCost: "$#{Cake.Formatters.price(calculator.extrasTotal())}",
      deliveryCost: "$#{Cake.Formatters.price(calculator.getDelivery())}",
      menuCost: "$#{Cake.Formatters.price(calculator.getPrice())}",
      foodCost: "$#{Cake.Formatters.price(calculator.foodTotal())}",
      gstCost: "$#{Cake.Formatters.price(calculator.gst())}",
      subtotalCost: "$#{Cake.Formatters.price(calculator.subtotal())}"
    }
