# see https://github.com/jashkenas/coffee-script/wiki/FAQ
window.implementing = (mixins..., classReference) ->
  for mixin in mixins
    for key, value of mixin::
      classReference::[key] = value
  classReference
