class Cake.Analytics

  @trackMenuClick: (buttonName, menu) ->
    ga('set', 'dimension1', menu.title)
    ga('set', 'dimension2', menu.id.toString())
    ga('set', 'dimension3', menu.position.toString())
    ga('send', 'event', 'button', 'click', buttonName, 0)

  @trackClick: (buttonName, value=0) ->
    ga('send', 'event', 'button', 'click', buttonName, value, { 'page': window.location.href})

  @trackError: (error) ->
    ga('send', 'event', 'error', error)

  @trackEnquiry: () ->
    ga('send', 'pageview', '/enquiry-sent')

  @trackMenuView: (menuUrl) ->
    ga('send', 'pageview', menuUrl)

  @ready: ->
    $(".js-track").click (e) ->
      buttonName = $(e.target).data("name")
      Cake.Analytics.trackClick(buttonName)
    $('.js-menu-track').click (e) ->
      target = $(e.target)
      buttonName = target.data("name")
      Cake.Analytics.trackMenuClick(buttonName, {
        position: target.data("position"),
        id: target.data("menuid"),
        title: target.data("menutitle")
      })
