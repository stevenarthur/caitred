describe 'SortableTable', ->
  beforeEach ->
    @$table = affix('table#js-table tbody.js-sortable').append(affix('tr td'))

  it 'creates a sortable for the given table rows', ->
    new Cake.Utils.SortableTable('#js-table', '.js-sortable', 'helperClass')
    sortable = $('.js-sortable').sortable('option')

    expect(sortable['axis']).toEqual('y')
    expect(sortable['containment']).toEqual('parent')
    expect(sortable['tolerance']).toEqual('pointer')

  it 'invokes the given callback on the update event', ->
    callback = jasmine.createSpy('updateCallback')
    new Cake.Utils.SortableTable('#js-table', '.js-sortable', 'helperClass').onUpdate(callback)

    $('#js-table .js-sortable').trigger('sortupdate')

    expect(callback).toHaveBeenCalled()
