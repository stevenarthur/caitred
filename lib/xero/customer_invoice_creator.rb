require_relative 'xero_client'

module Xero
  class CustomerInvoiceCreator
    class << self
      # rubocop:disable Metrics/AbcSize
      def from_enquiry(enquiry)
        Xero::XeroClient.client.Invoice.build(type: 'ACCREC').tap do |invoice|
          invoice.branding_theme_id = branding_theme(enquiry)
          invoice.line_amount_types = 'Inclusive'
          invoice.due_date = Date.today + 7.days
          invoice.reference = reference(enquiry)
          invoice.status = 'AUTHORISED'
          invoice.contact = contact(enquiry)
          add_line_items(invoice, enquiry)
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      def add_line_items(invoice, enquiry)
        enquiry.enquiry_items.each do |enquiry_item|
          invoice.add_line_item(food_line_item(enquiry_item))
        end
        add_delivery_line_item(invoice, enquiry)
        add_payment_line_item(invoice, enquiry)
      end

      def food_line_item(enquiry_item)
        {
          item_code: "#{enquiry_item.packageable_item.food_partner.id}-#{enquiry_item.packageable_item.id}",
          quantity: enquiry_item.quantity,
          description: "#{enquiry_item.packageable_item.title}",
          account_code: '200',
          unit_amount: enquiry_item.unit_price,
          tax_type: 'OUTPUT'
        }
      end

      def add_delivery_line_item(invoice, enquiry)
        return if enquiry.delivery_cost == 0
        invoice.add_line_item(delivery_line_item(enquiry))
      end

      def add_payment_line_item(invoice, enquiry)
        return if enquiry.payment_fee == 0
        invoice.add_line_item(payment_line_item(enquiry))
      end

      def delivery_line_item(enquiry)
        {
          unit_amount: enquiry.delivery_cost,
          quantity: 1,
          description: 'Delivery',
          account_code: '200',
          tax_type: 'OUTPUT'
        }
      end

      def payment_line_item(enquiry)
        payment_details = {
          unit_amount: enquiry.payment_fee_paid || enquiry.payment_fee,
          quantity: 1,
          description: 'Payment Fee',
          account_code: '200',
          tax_type: 'EXEMPTOUTPUT'
        }
        #payment_details[:tax_type] = 'EXEMPTOUTPUT' unless payment_fee_has_gst?(enquiry)
        payment_details
      end

      def branding_theme(enquiry)
        PaymentMethod.find(enquiry.payment_method).xero_template
      end

      def reference(enquiry)
        company = enquiry.address.try(:company)
        event_date = enquiry.event_date.try(:strftime, '%d-%b-%y')
        "#{company} #{event_date} (Order #{enquiry.id})"
      end

      def contact(enquiry)
        customer  = enquiry.customer
        contact = XeroClient.client.Contact.build(
          name: enquiry.address.try(:company),
          first_name: customer.first_name,
          last_name: customer.last_name,
          email_address: customer.email
        )
        contact.add_address(address(enquiry))
        contact
      end

      def address(enquiry)
        address = enquiry.customer.default_address
        {
          attention_to: enquiry.customer.name,
          address_type: 'POBOX',
          address_line1: address.try(:line_1),
          address_line2: address.try(:line_2),
          region: address.try(:suburb),
          postal_code: address.try(:postcode),
          country: 'Australia'
        }
      end

      def payment_fee_has_gst?(enquiry)
        PaymentMethod.find(enquiry.payment_method).gst_included
      end
    end
  end
end
