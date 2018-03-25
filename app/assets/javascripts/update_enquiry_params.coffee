$ ->
  $("#js--enquiry_parameters input, #js--enquiry_parameters select").on 'change', ((e) ->
    $("#js--enquiry_parameters").submit()
  ).bind this
