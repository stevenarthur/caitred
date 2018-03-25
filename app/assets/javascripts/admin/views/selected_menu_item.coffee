Cake.Templates.SelectedMenuItem = Haml '''
  %tr
    %td.js-packaged-item(data-id=id)
      %span{class: "ui-icon ui-icon-arrowthick-2-n-s"}
      =title
    %td.remove-packaged-item
      %a.js-remove-packaged-item(data-id=id data-title=title)
        Remove
'''
