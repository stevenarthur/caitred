Cake.Templates.EquipmentItem = Haml '''
  %tr(id="js-equipment-item-#{index}")
    %td
      %input.form-control.input-sm(type='text' name="menu[equipment_extras][items][][title]" placeholder="title")
    %td
      %input.form-control.input-sm(type='text' name="menu[equipment_extras][items][][price]" placeholder="$")
    %td
      %a.btn.btn-danger.btn-inline.js-remove-equipment-item(data-menu=index)
        %span.glyphicon.glyphicon-remove.js-remove-equipment-item(data-menu=index)
'''
