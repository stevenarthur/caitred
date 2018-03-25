class Cake.MenuItemSelect
  # Remove it from the Select
  # Remove it from the Extras Select (Food items only)

  constructor: (@inputSelector, @listSelector, @type, @hiddenSelector, @independent=false) ->
    @template = Cake.Templates.SelectedMenuItem
    @inputField().on 'change', @addItem
    $(document).on(Cake.Events.MENU_ITEM_SELECTED, @removeFromSelect)
    $(document).on(Cake.Events.MENU_ITEM_REMOVED, @addToSelect)
    new Cake.Utils.SortableTable(@listSelector, '.js-sortable', 'draggable').onUpdate(@sortItems)
    @list().find('.js-remove-packaged-item').on 'click', @removeFromPackage

  inputField: ->
    @field ||= $(@inputSelector)

  currentlySelected: ->
    @inputField().find('option:selected')

  hiddenField: ->
    @hiddenElement ||= $(@hiddenSelector)

  list: ->
    @listElement ||= $(@listSelector)

  selectedItems: ->
    ids = @hiddenField().val() || ''
    _.reject(ids.split(','), (val) ->
      _.isEmpty(val)
    )

  renderParams: ->
    title: @currentlySelected().text()
    id: @currentlySelected().val()

  addItem: =>
    params = @renderParams()
    html = $(@template(params))
    html.find('.js-remove-packaged-item').on('click', @removeFromPackage)
    @list().append(html)
    items = @selectedItems()
    items.push(params.id)
    @hiddenField().val(items.join(','))
    @triggerSelectedEvent()

  removeFromField: (id) ->
    items = _.reject(@selectedItems(), (val) ->
      "#{val}" == "#{id}"
    )
    @hiddenField().val(items.join(','))

  removeFromPackage: (e) =>
    target = $(e.target)
    id = target.data('id')
    @removeFromField(id)
    @triggerRemovedEvent(id, target.data('title')) unless @independent
    target.closest('tr').remove()

  removeFromSelect: (e) =>
    option = @inputField().find("option[value=#{e.selectedOption.id}]")
    option.remove()

  addToSelect: (e) =>
    return if @independent
    return unless e.selectedOption.type == @type
    option = $('<option>').text(e.selectedOption.title).val(e.selectedOption.id)
    @inputField().append(option)

  sortItems: =>
    itemIds = _.map(@list().find('.js-packaged-item'), (item) ->
      $(item).data('id')
    )
    @hiddenField().val(itemIds.join(','))

  triggerRemovedEvent: (id, title) ->
    params =
      selectedOption:
        id: id
        title: title
        type: @type
    e = $.Event(Cake.Events.MENU_ITEM_REMOVED, params)
    $(document).trigger(e)

  triggerSelectedEvent: ->
    params =
      selectedOption:
        id: @currentlySelected().val()
        title: @currentlySelected().text()
        type: @type
    e = $.Event(Cake.Events.MENU_ITEM_SELECTED, params)
    $(document).trigger(e)
