describe 'MenuItemSelect', ->
  beforeEach ->
    @$select = affix('select#js-select')
    @$select.affix('option[value=1]').text('lemon')
    @$select.affix('option[value=2]').text('orange')
    @$list = affix('table#js-table').append(
      affix('tr td.js-packaged-item[data-id=3]').append(affix('td a.js-remove-packaged-item[data-title="apple"][data-id=3]')),
      affix('tr td.js-packaged-item[data-id=5]').append(affix('td a.js-remove-packaged-item[data-title="pear"][data-id=5]'))
    )

    @$hidden = affix('input#js-hidden[type="hidden"][value="3,5"]')

  describe 'ordering items', ->
    beforeEach ->
      @sortableMock = jasmine.createSpyObj('sortableTable', ['onUpdate'])
      spyOn(Cake.Utils, 'SortableTable').and.returnValue(@sortableMock)
      @sortableMock.onUpdate.and.callFake((callback) => @updateCallback = callback)
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')

    it 'creates a sortable table', ->
      expect(Cake.Utils.SortableTable).toHaveBeenCalledWith('#js-table', '.js-sortable', 'draggable')

    it 'updates the list of item ids', ->
      @updateCallback()
      expect(@$hidden.val()).toBe '3,5'

  describe 'adding an item', ->
    it 'adds an element to the list', ->
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      @$select.val(2).change()
      expect(@$list.find('tr').size()).toBe 3

    it 'raises an event', (done) ->
      eventRaised = false
      $(document).on(Cake.Events.MENU_ITEM_SELECTED, ->
        eventRaised = true
        done()
      )
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      @$select.val(2).change()
      expect(eventRaised).toBeTruthy()

    it 'passes the option selected in the raised event',  ->
      option = {}
      $(document).on(Cake.Events.MENU_ITEM_SELECTED, (e) ->
        option = e.selectedOption
      )
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      @$select.val(2).change()
      expect(option).toBeDefined()
      expect(option.title).toBe 'orange'
      expect(option.id).toBe '2'

    it 'responds to the event raised by removing the selected option', ->
      new Cake.MenuItemSelect('#js-select', '#js-table')
      e = $.Event(Cake.Events.MENU_ITEM_SELECTED, selectedOption: { id: '1', title: 'lemon'})
      $(document).trigger(e)
      expect(@$select.find('option').size()).toBe 1

    it 'adds the id to the hidden field', ->
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden', '#js-hidden')
      @$select.val(2).change()
      @$select.val(1).change()
      expect(@$hidden.val()).toBe '3,5,2,1'

  describe 'removing an item', ->
    it 'responds to a delete event by adding the option back in', ->
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      params =
        selectedOption:
          id: '3'
          title: 'banana'
          type: 'food'
      e = $.Event(Cake.Events.MENU_ITEM_REMOVED, params)
      $(document).trigger(e)
      expect(@$select.find('option').size()).toBe 3

    it 'only adds back options that match the type', ->
      new Cake.MenuItemSelect('#js-select', '#js-table', 'equipment', '#js-hidden')
      params =
        selectedOption:
          id: '3'
          title: 'banana'
          type: 'food'
      e = $.Event(Cake.Events.MENU_ITEM_REMOVED, params)
      $(document).trigger(e)
      expect(@$select.find('option').size()).toBe 2

    it 'deletes the item from the table when remove link is clicked', ->
      new Cake.MenuItemSelect('#js-select', '#js-table')
      @$list.find('.js-remove-packaged-item').click()
      expect(@$list.find('tr').size()).toBe 0

    it 'triggers an event when the remove link is clicked', (done) ->
      eventRaised = false
      $(document).on(Cake.Events.MENU_ITEM_REMOVED, ->
        eventRaised = true
        done()
      )
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      @$list.find('.js-remove-packaged-item').click()
      expect(eventRaised).toBeTruthy()

    it 'passes the details in the raised event for the remove link',  ->
      option = {}
      $(document).on(Cake.Events.MENU_ITEM_REMOVED, (e) ->
        option = e.selectedOption
      )
      new Cake.MenuItemSelect('#js-select', '#js-table')
      $(@$list.find('.js-remove-packaged-item').first()).click()
      expect(option).toBeDefined()
      expect(option.title).toBe 'apple'
      expect(option.id).toBe 3

    it 'removes the value from the hidden field', ->
      new Cake.MenuItemSelect('#js-select', '#js-table', 'food', '#js-hidden')
      @$select.val(2).change()
      @$select.val(1).change()
      $items = @$list.find('.js-remove-packaged-item')
      $($items[1]).click()
      expect(@$hidden.val()).toBe '3,2,1'
