class Cake.CustomerCollection

  load: -> 
    $.getJSON("/admin/customers.json")

  populate: ->
    promise = $.Deferred()
    @load().done((data) =>
      @customers = data
      promise.resolve()
    )
    promise
    
  autocompleteList: -> 
    $.map(@customers, (customer) -> 
      { 
        value: customer.description
        id: customer.id
      }
    )
