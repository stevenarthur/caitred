onLoadClasses = [
                  Cake.Enquiries,
                  Cake.AdminUser,
                  Cake.FoodPartners,
                  Cake.AdminMenu,
                  Cake.PackageableItems,
                  Cake.MenuPackages,
                  Cake.Addresses,
                  Cake.EditDayFields
                ]

unless Cake.loaded
  _.each onLoadClasses, (klass) ->
    if klass
      $(klass.ready);
      $(document).on('page:load', klass.ready);
  Cake.loaded = true
