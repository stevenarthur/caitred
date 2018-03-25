class Cake.MenuPackages

  @ready: ->
    foodSelect = new Cake.MenuItemSelect('#js-food-items', '#js-food-items-list', 'food', '#js-menu-items-hidden')
    extrasSelect = new Cake.MenuItemSelect('#js-extra-items', '#js-extra-items-list', 'food', '#js-extra-items-hidden')
    equipmentSelect = new Cake.MenuItemSelect('#js-equipment-items', '#js-equipment-items-list', 'equipment', '#js-extra-items-hidden')
    alternativeSelect = new Cake.MenuItemSelect('#js-alternative-items', '#js-alternative-items-list', 'alternatives', '#js-alternative-items-hidden')
