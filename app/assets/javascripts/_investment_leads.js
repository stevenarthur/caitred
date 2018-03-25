$(function() {

  $('form.modern').on('ajax:error', function(e, data, status, xhr){
    e.preventDefault();
    var model = $(this).data('model')
    $(this).render_form_errors(model, JSON.parse(data.responseText));
  });

  $('form#new_investment_lead').on('ajax:success', function(e, data, status, xhr){
    $(this).slideUp();
    $(this).after("<p>Thank you for your interest. We'll be in touch!</p>");
    fbq('track', 'Lead');
  });

  $('form#new_postcode_lead').on('ajax:success', function(e, data, status, xhr){
    $(".js--service-postcode-info").slideUp();
    $(this).slideUp();
    $(this).after("<p>Thank you for your interest!</p>");
    fbq('track', 'Lead');
  });

});
