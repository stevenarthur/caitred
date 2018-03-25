$(function() {

  if($("#js--track-search").length > 0){
    $("#js--track-search").on('submit', function(e){
      var searchSlug = $("#js--slug").val();
      analytics.track('homepage postcode search', { locality: searchSlug });
      fbq('track', 'Search');
    });
  };

  // Proceed To Checkout Form (from partner show page)
  // IMPORTANT:: THIS NEEDS TO BE WRAPPED TO ENSURE IT GETS RE-CALLED WHEN DATE, TIME OR
  // POSTCODE IS MODIFIED. I THINK THIS WAS THE INTENTION OF WRAPPING IN A CLASS. 
  // CHECK WITH GAVIN.
  if($("#js--proceed-to-checkout").length > 0){
    $("#js--proceed-to-checkout").on('submit', function(e){
      form = $("#js--proceed-to-checkout");
      e.preventDefault();
      analytics.track('proceeded to checkout page', { 
        enquiry_id: form.data('enquiry-id'),
        food_partner: form.data('food-partner'),
        food_partner_id: form.data('food-partner-id'),
        event_date: form.find("#enquiry_event_date").val(), // IMPORTANT NOTE
        event_time: form.find("#enquiry_event_time").val(), // IMPORTANT NOTE
        postcode: form.find("#enquiry_postcode").val() // IMPORTANT NOTE
      });
      fbq('track', 'InitiateCheckout');
      $("#js--proceed-to-checkout").get(0).submit();
    });
  };

  
  // Complete Checkout Details Page
  if($("#js--new-order").length > 0){
    $("#js--new-order").on('submit', function(e){
      form = $("#js--new-order");
      e.preventDefault();
      analytics.track('completed checkout details page', { 
        enquiry_id: form.data('enquiry-id'),
        food_partner: form.data('food-partner'),
        food_partner_id: form.data('food-partner-id')
      });
    });
  };

});
