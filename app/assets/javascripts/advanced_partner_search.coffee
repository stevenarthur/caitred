class Cake.AdvancedPartnerSearch
  
  sort_direction: 'ASC'
  
  @ready: ->
    new Cake.AdvancedPartnerSearch().setup()

  build_query: ->
    if $('.js--sort-partners-by').length > 0
      sort_value = $('.js--sort-partners-by')[0].value # Error if no partners
    else
      sort_value = 'company_name'
    postcode = $('.js--postcode-search')[0].value
    date = $('.js--datepicker-search')[0].value
    eat_time = $('.js--timepicker-search')[0].value
    event_type = $("input[name='event_type']:checked")[0].value if $("input[name='event_type']:checked").length
    price_low = $('.js--price-low-checkbox')[0].checked
    price_medium = $('.js--price-medium-checkbox')[0].checked
    price_high = $('.js--price-high-checkbox')[0].checked

    query = '?sort=' + sort_value
    query += '&direction=' + @sort_direction
    query += '&postcode=' + postcode unless postcode == ''
    query += '&date=' + date unless date == ''
    query += '&eat_time=' + eat_time unless eat_time == ''
    query += '&event_type=' + event_type if event_type
    query += '&price_low=' + price_low if price_low
    query += '&price_medium=' + price_medium if price_medium
    query += '&price_high=' + price_high if price_high

    return query

  search: ->
    $.get window.location.pathname + '/search' + @build_query(), (response) ->
      $('.js--partner-listing').html(response)
      $('.js--fa-search-item').matchHeight()

  setup: ->
    $('.js--postcode-search').on 'input', ((e) ->
      @search()
    ).bind this

    $('.js--advanced-search-item').on 'change', ((e) ->
      @search()
    ).bind this

    $('.js--toggle-sort-partners-direction').on 'click', ((e) ->
      @sort_direction = if @sort_direction == "ASC" then "DESC" else "ASC"
      $('.js--toggle-sort-partners-direction i').toggleClass('glyphicon-chevron-up').toggleClass('glyphicon-chevron-down')
      @search()
    ).bind this

    $('.js--clear-advanced-form').on 'click', (() ->
      $('.js--postcode-search')[0].value = ''
      $('.js--datepicker-search')[0].value = ''
      $('.js--timepicker-search')[0].value = ''
      $("input[name='event_type']:checked")[0].checked = false if $("input[name='event_type']:checked").length
      $('.js--price-low-checkbox')[0].checked = false
      $('.js--price-medium-checkbox')[0].checked = false
      $('.js--price-high-checkbox')[0].checked = false

      @search()
    ).bind this
