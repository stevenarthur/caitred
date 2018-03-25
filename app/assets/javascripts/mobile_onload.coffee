onLoadClasses = [Cake.Reviews]

_.each onLoadClasses, (klass) ->
  $(klass.ready);
  $(document).on('page:load', klass.ready);
