Cake.Utils or= {}
class Cake.Utils.SortableTable
  constructor: (tableSelector, sortableRowsSelector, @helperClass) ->
    $(tableSelector + ' td').each(() -> $(this).width($(this).width()))
    @sortableElement = $(tableSelector + " > " + sortableRowsSelector).sortable({
      axis: "y",
      containment: "parent",
      tolerance: "pointer",
      helper: @helper,
    }).disableSelection()

  onUpdate: (callback) =>
    @sortableElement.on('sortupdate', callback)

  helper: (e, ui) =>
    helper = ui.clone()
    $(helper).addClass(@helperClass)
