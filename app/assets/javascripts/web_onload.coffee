onLoadClasses = [Cake.Menus, Cake.Analytics, Cake.WebEnquiries, Cake.ResetPassword, Cake.Reviews, Cake.Poll, Cake.AdvancedPartnerSearch, Cake.Sticky]

_.each onLoadClasses, (klass) ->
  $(klass.ready);
  $(document).on('page:load', klass.ready);
