$.fn.render_form_errors = (model_name, errors) ->
  form = this
  this.clear_form_errors()

  $.each(errors, (field, messages) ->
    input = form.find('input, select, textarea').filter(->
      name = $(this).attr('name')
      if name
        name.match(new RegExp(model_name + '\\[' + field + '\\(?'))
    )
    input.closest('.form-group').addClass('field_with_errors')
    input.parent().append('<span class="help-block help-block--error animated fadeIn">' + $.map(messages, (m) -> m.charAt(0).toUpperCase() + m.slice(1)).join('<br />') + '</span>')
  )

$.fn.clear_form_errors = () ->
  this.find('.input').removeClass('field_with_errors')
  this.find('span.help-block').remove()
