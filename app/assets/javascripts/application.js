// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, partner/assets/javascripts,
// or partner/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require underscore
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery-ui/sortable
//= require bootstrap
//= require bootstrap-timepicker
//= require sortable
//= require typeahead
//= require json2
//= require judge
//= require haml
//= require_tree ./common
//= require_tree ./admin/views
//= require trix
//= require admin/enquiries
//= require admin/enquiry_form
//= require admin/addresses
//= require admin/admin_user
//= require admin/admin_menu
//= require admin/menu_item_select
//= require admin/menu_packages
//= require admin/food_partners
//= require admin/food_partner_postcodes
//= require admin/packageable_items
//= require admin/customer_autocomplete
//= require admin/customer_collection
//= require admin/edit_day_fields
//= require admin/admin_onload
//= require admin/enquiry_progressor
//= require _form_errors
//= require _investment_leads
//= require _homepage_search
//= require jquery.autocomplete.js

$(function() {
  $('#js--lookup').devbridgeAutocomplete({
    serviceUrl: '/autocomplete/postcodes',
    dataType: 'json',
    type: 'post',
    minChars: 1,
    noCache: true,
    onSelect: function (suggestion) {
      $("#js--slug").val(suggestion.data);
    },
    onSearchComplete: function (query, suggestions) {
    }
  });

  if($('.js--partner-sidebar-event-types').length > 0){
    var sidebar = $('.js--partner-sidebar-event-types')

    // Show first menu on partner page
    var first_event_type = $(sidebar).find('li:first').data('event-type');
    $('section[data-event-type]').hide();
    $('section[data-event-type='+first_event_type+']').show();
    $('li[data-event-type='+first_event_type+']').addClass('active');

    // Toggle Menus
    $(sidebar).find('a').on('click', function(){
      $('section[data-event-type]').hide();
      $('section[data-event-type='+ $(this).parent().data('event-type')+']').show();

      $('li[data-event-type]').removeClass('active');
      $('li[data-event-type='+ $(this).parent().data('event-type')+']').addClass('active');
    });

  };
});
