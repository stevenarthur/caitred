class Cake.CustomerAutocomplete

  constructor: ($el, $hiddenEl) -> 
    @$el = $el
    @$hiddenEl = $hiddenEl
    @$el.addClass("form-control input-sm")
    @$el.on 'keypress', (e) =>
      if e.charCode == 13
        @$el.typeahead('close')
        false
    @loadData()

  loadData: -> 
    @customerCollection = new Cake.CustomerCollection()
    @customerCollection.populate().done(@initTypeahead)

  initTypeahead: =>
    options = 
      minLength: 3
      highlight: true

    dataSet = 
      source: @queryDataSet()
      name: 'customers'

    @$el.typeahead options, dataSet
    @$el.on "typeahead:selected typeahead:autocompleted", (e, customer) =>
      @setCustomerId(e, customer)
      @$el.typeahead('close')


  setCustomerId: (e, customer) ->
    @$hiddenEl.val(customer.id)


  queryDataSet: ->
    customers = @customerCollection.autocompleteList()
    findMatches = (query, cb) ->
      matches = []
      substrRegex = new RegExp(query, 'i')

      $.each(customers, (i, customer) -> 
        matches.push(customer) if substrRegex.test(customer.value)
      )

      cb(matches) 
    # customers = new Bloodhound(
    #     datumTokenizer: Bloodhound.tokenizers.obj.whitespace 'value'
    #     queryTokenizer: Bloodhound.tokenizers.whitespace
    #     local: @customerCollection.autocompleteList()
    #   )
    # customers.initialize()
    # customers.ttAdapter()
 
