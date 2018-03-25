Cake.AdminMenu = implementing Cake.JudgeForm, class Cake._AdminMenu

  @ready: ->
    Cake.AdminMenu.menu = menu = new Cake.AdminMenu()
    menu.setupForm()
    menu.setupExtrasValidation()
    $('#js-add-menu-item').on('click', menu.addMenuItem)
    $('#js-add-extra-item').on('click', menu.addExtraItem)
    $('#js-add-equipment-item').on('click', menu.addEquipmentItem)
    menu.bindRemoveEvents()

  priceValidationString: ->
    $("#js-price").attr("data-validate")

  bindRemoveEvents: ->
    $('.js-remove-menu-item').on('click', @removeMenuItem)
    $('.js-remove-extra-item').on('click', @removeExtraItem)
    $('.js-remove-equipment-item').on('click', @removeEquipmentItem)

  name: ->
    "menu"

  setupExtrasValidation: ->
    $(".js-extras-price").attr("data-validate", @priceValidationString())

  fieldsToValidate: ->
    fields = ['js-title', 'js-price', 'js-min-attendees', 'js-priority-order']
    $(".js-extras-price").each ->
      fields.push $(this).attr("id")
    fields

  addMenuItem: =>
    @addItem("menu")

  addExtraItem: =>
    $item = $(@addItem("extra"))
    id = $item.find(".js-extras-price").attr("id")
    $("##{id}").attr("data-validate", @priceValidationString())

  addEquipmentItem: =>
    @addItem("equipment")

  removeMenuItem: (e) ->
    menuIndex = $(e.target).data("menu")
    $("#js-menu-item-#{menuIndex}").remove()

  removeExtraItem: (e) ->
    menuIndex = $(e.target).data("menu")
    $("#js-extra-item-#{menuIndex}").remove()

  removeEquipmentItem: (e) ->
    menuIndex = $(e.target).data("menu")
    $("#js-equipment-item-#{menuIndex}").remove()

  addItem: (type) =>
    $items = $("#js-#{type}-items")
    index = $items.find("tr").length - 1
    $item = @createItem(type, index)
    $items.append $item
    $(".js-no-#{type}-items").hide()
    @bindRemoveEvents()
    $items.show()
    $item

  createItem: (type, index) ->
    @templates()[type]({index: index})

  templates: ->
    menu: Cake.Templates.MenuItem
    extra: Cake.Templates.ExtrasItem
    equipment: Cake.Templates.EquipmentItem



