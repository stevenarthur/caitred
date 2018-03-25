$(function() {

  $('form#js--track-search').on('ajax:error', function(e, data, status, xhr){
    e.preventDefault();
    var parsedData = JSON.parse(data.responseText)
    $("#postcode_lead_postcode").val(parsedData.postcode);
    $(".js--service-postcode").html(parsedData.postcode);
    $("#js--service-postcode-wrap").slideDown();
  });


});
