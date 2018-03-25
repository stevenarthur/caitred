//= require underscore
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require segment
//= require sticky-kit.min
//= require bootstrap-timepicker
//= require jquery.autocomplete.js
//= require haml
//= require judge
//= require chart
//= require_tree ./common
//= require analytics
//= require store
//= require reset_password
//= require menus
//= require enquiry_calculator
//= require enquiry_price_view
//= require enquiry_popup
//= require advanced_partner_search
//= require sticky
//= require reviews
//= require poll
//= require_tree ./views
//= require web_enquiries
//= require formatters
//= require prototype
//= require web_onload
//= require jquery-ui/datepicker
//= require spin
//= require validation/registration
//= require validation/new_quote
//= require validation/new_enquiry
//= require validation/new_caitredette
//= require jquery.matchHeight-min.js
//= require update_enquiry_params
//= require _testimonials.js
//= require _form_errors
//= require _investment_leads.js
//= require _homepage_search.js

$(function() {

  $('.js--nav-toggle').on('click', function(){
    $(this).toggleClass('is-active');
    $('.js--nav').toggleClass('is-active');
  });

  $('.js--title').matchHeight();
  $('.js--fa-search-item').matchHeight();
  $('.js--match-height').matchHeight();
  $('.js-timepicker').timepicker();
  $('.caitredette__rate').matchHeight();

  if($('.js--partner-sidebar-event-types').length > 0){
    var sidebar = $('.js--partner-sidebar-event-types')

    // Show first menu on partner page
    var first_event_type = $(sidebar).find('li:first').data('event-type');
    $('section[data-event-type]').hide();
    $('section[data-event-type='+first_event_type+']').show();
    $('li[data-event-type='+first_event_type+']').addClass('active');

    // Toggle Menus
    $(sidebar).find('a').on('click', function(e){
      $('section[data-event-type]').hide();
      $('section[data-event-type='+ $(this).parent().data('event-type')+']').show();

      $('li[data-event-type]').removeClass('active');
      $('li[data-event-type='+ $(this).parent().data('event-type')+']').addClass('active');
      $('.js--match-height').matchHeight({
        byRow: false
      });

      $('html, body').animate({
          scrollTop: ($('.js--menu-wrap').offset().top - 90) + 'px'
      }, 'fast');
    });

  };

  if($('#js--lookup').length > 0){
    $('#js--lookup').devbridgeAutocomplete({
      serviceUrl: '/autocomplete/postcodes',
      dataType: 'json',
      type: 'post',
      minChars: 2,
      noCache: true,
      onSelect: function (suggestion) {
        $("#js--slug").val(suggestion.data);
      },
      onSearchComplete: function (query, suggestions) {
      }
    });
  };

  if($('#js--checkout-time').length > 0){
    $('#js--checkout-time select').on('change', function(){
      timeString = $('#js--checkout-time select').find('option:selected').val()
      am_or_pm = timeString.split(' ').pop()
      hour = ""
      if(timeString.split(' ')[0].split(':').pop() == "00"){
        hour = timeString.split(' ')[0].split(':')[0] - 1
        minute = (Math.round(timeString.split(' ')[0].split(':').pop() + 45)).toFixed()
      }else{
        hour = timeString.split(' ')[0].split(':')[0]
        minute = timeString.split(' ')[0].split(':').pop() - 15
        if(minute == "0"){ minute = "00" }
      };
      $('.js--delivery-time').html(hour + ":" + minute + " " + am_or_pm);
    });
  };

  if($('#js--main-contact').length > 0){
    $('#js--additional-contact').hide();
    $('#js--main-contact input, #js--main-contact label').click(function() {
       if($('#main_contact_yes').is(':checked')) {
         $("#js--additional-contact").hide();
         $("#js--additional-contact input").val("");
       };
       if($('#main_contact_no').is(':checked')) {
         $("#js--additional-contact").show();
       };
    });
  };

  if($(".fp-modal").length > 0){
    var updateButtonTotal = function(modalItem){
      modal = $(modalItem).closest('.fp-modal');
      price = 0.00
      modal.find('.fp-modal-item').each(function(){
        item = $(this);
        itemCost = item.find(".price").data('price');
        itemQty = item.find("select").val();
        itemSubtotal = parseFloat((itemCost * itemQty));
        price = price + itemSubtotal;
      });
      modal.find("input[type='submit']").val("Add to Cart ($"+ Number(price).toFixed(2) +")");
    };
    $(".fp-modal").each(function(){
      updateButtonTotal($(this));
    });

    $(".fp-modal select").on('change', function(){
      updateButtonTotal($(this));
    });
  };

});
