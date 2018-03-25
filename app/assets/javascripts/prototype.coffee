class Cake.Prototype

  @ready: ->
    $("#js-event-date").blur ->
      if $("#js-event-date").val() == "fail"
        $(".confirm-date")
          .removeClass("unconfirmed")
          .removeClass("confirmed")
          .addClass("unavailable")
        $(".confirm-date .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-ok-sign")
          .addClass("glyphicon-remove-sign")
        $(".confirm-date h2").text("This date is not available")
      else
        $(".confirm-date")
          .removeClass("unconfirmed")
          .removeClass("unavailable")
          .addClass("confirmed")
        $(".confirm-date .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-remove-sign")
          .addClass("glyphicon-ok-sign")
        $(".confirm-date h2").text("You are booking for #{$("#js-event-date").val()}")

    $("#js-attendees").blur ->
      if $("#js-attendees").val() == "fail"
        $(".confirm-attendees")
          .removeClass("unconfirmed")
          .removeClass("confirmed")
          .addClass("unavailable")
        $(".confirm-attendees .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-ok-sign")
          .addClass("glyphicon-remove-sign")
        $(".confirm-attendees h2").text("Please confirm the number of Eaters and any dietary requirements")
      else
        $(".confirm-attendees")
          .removeClass("unconfirmed")
          .removeClass("unavailable")
          .addClass("confirmed")
        $(".confirm-attendees .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-remove-sign")
          .addClass("glyphicon-ok-sign")
        $(".confirm-attendees h2").text("You are booking for #{$("#js-attendees").val()} people")


    $("#js-location").blur ->
      if $("#js-location").val() == "fail"
        $(".confirm-location")
          .removeClass("unconfirmed")
          .removeClass("confirmed")
          .addClass("unavailable")
        $(".confirm-location .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-ok-sign")
          .addClass("glyphicon-remove-sign")
        $(".confirm-location h2").text("Please confirm your event location")
      else
        $(".confirm-location")
          .removeClass("unconfirmed")
          .removeClass("unavailable")
          .addClass("confirmed")
        $(".confirm-location .glyphicon")
          .removeClass("glyphicon-question-sign")
          .removeClass("glyphicon-remove-sign")
          .addClass("glyphicon-ok-sign")
        $(".confirm-location h2").text("You are booking an event in #{$("#js-location").val()}")
