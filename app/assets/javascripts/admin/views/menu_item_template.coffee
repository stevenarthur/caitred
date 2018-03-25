Cake.Templates.MenuItem = Haml '''
  %tr(id="js-menu-item-#{index}")
    %td
      %input.form-control.input-sm(type='text' name="menu[items][items][][title]" placeholder="title")
      %textarea.form-control.input-sm(type='text' name="menu[items][items][][description]" placeholder="description")
    %td
    %td
      %a.btn.btn-danger.btn-inline.js-remove-menu-item(data-menu=index)
        %span.glyphicon.glyphicon-remove.js-remove-menu-item(data-menu=index)
'''
