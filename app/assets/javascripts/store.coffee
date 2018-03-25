class Cake.Store

  @set: (key, value) ->
    key = "cake.#{key}"
    localStorage.setItem(key, value)

  @get: (key, defaultValue) ->
    key = "cake.#{key}"
    localStorage.getItem(key) || defaultValue
