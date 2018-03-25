beforeEach ->
  
  jasmine.addMatchers 
    
    toHaveCssClass: ->
      compare: (actual, className) ->
        pass: $(actual).hasClass(className)

    toHaveNoContent: ->
      compare: (actual) ->
        pass: $(actual).html() == ""

    toHaveContent: ->
      compare: (actual, expected) ->
        pass: $(actual).html() == expected
