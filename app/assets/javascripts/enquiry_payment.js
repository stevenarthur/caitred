var enquiry;

jQuery(function() {
  if ($("#js--payment").length > 0) {
    Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
    return enquiry.setupForm();
  }
});

enquiry = {
  setupForm: function() {
    return $('#js--payment').on('submit', function(e) {
      e.preventDefault();
      $('#js--order-button').prop('disabled', true);
      enquiry.processCard();
    });
  },
  processCard: function() {
    var card;
    card = {
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    Stripe.createToken(card, enquiry.handleStripeResponse);
  },

  handleStripeResponse: function(status, response) {
    if (response.error) { // Problem!
      $('#js--stripe_error').addClass('alert alert-danger').text(response.error.message);
      $('#js--order-button').prop('disabled', false);
    } else { // Token was created!
      $('#stripe_card_token').val(response.id);
      var $form = $("#js--payment");
      fbq('track', 'AddPaymentInfo');
      analytics.track('submitted payment', {
        enquiry_id: $form.data('enquiry-id'),
        food_partner: $form.data('food-partner'),
        food_partner_id: $form.data('food-partner-id')
      });
      $form.get(0).submit();
    }
  }
};
