class Cake.Poll

  @ready: ->
    new Cake.Poll('team_lunch')

  constructor: (@pollTag) ->
    return unless $("#js-#{@pollTag}").length > 0
    @$elem = $("#js-#{@pollTag}")
    form = $("#js-#{@pollTag}-form")
    @resultsUrl = window["poll#{@pollTag}ResultsUrl"]

    @$elem.find('.js-vote').on 'click', (e) =>
      e.preventDefault()
      $.post(form.attr('action'), form.serializeArray())
        .fail(@displayError)
        .done(@loadResults)

    @$elem.find('.js-show-results').on 'click', (e) =>
      e.preventDefault()
      @loadResults()

    if $("#js-#{@pollTag}-questions").length == 0
      @loadResults()

  displayError: ->

  showSurvey: ->
    $("#js-#{@pollTag}-results").show()

  hideQuestions: ->
    $("#js-#{@pollTag}-questions").hide()

  loadResults: =>
    @hideQuestions()
    @showSurvey()
    $.get(@resultsUrl)
      .done (data) =>
        @showChart(data)

  showChart: (data) ->
    # colours = ["#A587B0", "#FDEBC2", "#F4DBFD", "#98CAB5", "#ffffff"]
    # colours = ["#CA9BB3", "#974770", "#F4DBFD", "#FDFC9C", "#CAC49B"]
    colours = ["#CAAF9B", "#A75113", "#FDE0DB", "#9CFDB4", "#9DCA9B"]
    datasets = []
    for answer, i in data.results
      result = {}
      result.label = answer.answer
      result.fillColor = colours[i]
      result.data = [answer.votes]
      datasets.push result
    chartData = {
      labels: [""],
      datasets: datasets
    }
    options = {
      scaleFontColor: "#fff",
      scaleLineColor: "#fff",
      barShowStroke : false
    }
    ctx = document.getElementById("js-#{@pollTag}-chart").getContext("2d")
    resultsChart = new Chart(ctx).Bar(chartData, options);

    $("#js-#{@pollTag}-legend").html(resultsChart.generateLegend())
