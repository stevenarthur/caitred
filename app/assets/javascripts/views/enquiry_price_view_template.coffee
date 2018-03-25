Cake.Templates.EnquiryPriceView = Haml '''
  .panel.panel-default.menu-cost.js-cost-info
    .panel-heading
      Your Estimated Price
    .panel-body
      .js-food-cost.price=foodCost
      .food-cost
        Food for
        %span.js-attendees=" #{attendees} "
        people at
        %span.js-menu-cost=" #{menuCost} "
        per person
      .js-extras-cost.price=extrasCost
      .extras-cost
        Optional Extras
        :for extra in extras
          .js-extras-text.extras-text
            #{extra.title} for #{attendees} people
              :if (extra.price > 0)
                =" at $#{Cake.Formatters.price(extra.price)}"
              :if (extra.price == 0)
                =" (free)"
      .price.js-delivery-cost=deliveryCost
      .delivery-cost
        Delivery
      .js-sub-total-cost.price.total=subtotalCost
      .total
        Subtotal (Before GST):
      .price.js-gst-cost=gstCost
      .gst
        GST
      .js-total-cost.price.total=totalCost
      .total
        Total (incl GST)
'''
