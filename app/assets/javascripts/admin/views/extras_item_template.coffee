Cake.Templates.ExtrasItem = Haml '''
  %tr.js-field-group(id="js-extra-item-#{index}")
    %td
      %input.form-control.input-sm(type='text' name="menu[extras][items][][title]" placeholder="title")
      %textarea.form-control.input-sm(type='text' name="menu[extras][items][][description]" placeholder="description")
    %td
      %input.form-control.input-sm.js-extras-price(id="js-menu-item-price-#{index}" type='text' name="menu[extras][items][][price]" placeholder="$")
      %span.glyphicon.form-control-feedback
      %span.js-errors.error-message
    %td
      %a.btn.btn-danger.btn-inline.js-remove-extra-item(data-menu=index)
        %span.glyphicon.glyphicon-remove.js-remove-extra-item(data-menu=index)
'''
