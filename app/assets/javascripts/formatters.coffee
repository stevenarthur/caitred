class Cake.Formatters

  @price: (price_string) ->
    parseFloat(price_string).toFixed(2).replace(".00", "")
