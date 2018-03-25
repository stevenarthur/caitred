Cake.PackageableItems = implementing Cake.JudgeForm, class Cake._PackageableItems

  @ready: ->
    Cake.PackageableItems.items = items = new Cake.PackageableItems()
    items.setupForm()

  name: ->
    "packageable-item"

  fieldsToValidate: ->
    ['js-title', 'js-cost', 'js-cost-as-extra']

