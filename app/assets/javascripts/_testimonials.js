$(function() {
  if($("#js--testimonials").length > 0){

    var testimonials = $('#js--testimonials > div');
    var index = 0;

    displayTestimonial();

    function displayTestimonial() {
      //Check to see if we need to reset back to the first index
      if(index + 1 > testimonials.length) { index=0; }
      
      //Display a testmonial and when testimonial is complete fade it out
      $(testimonials[index]).fadeIn(500, function() {

          //Fade testimonial out and when complete increment the current span index and 
          $(testimonials[index]).delay(4000).fadeOut(500, function() {
             index++;
             //Have the function call itself                                 
             displayTestimonial();
           });
      });
    }


  }
})
