require_relative 'xero_client'

# This is the 'bill' that should be created for each enquiry so that Iris doesn't
# need to send this manually each time.

class Xero::SupplierInvoiceCreator
  class << self

    def from_enquiry(enquiry)
      Xero::XeroClient.client.Invoice.build(type: 'ACCPAY').tap do |invoice|
        invoice.branding_theme_id = branding_theme(enquiry)
        invoice.line_amount_types = 'Inclusive'
        invoice.due_date = Date.today + 7.days
        invoice.reference = reference(enquiry)
        invoice.status = 'SUBMITTED'
        invoice.contact = contact(enquiry)
        add_catering_costs(invoice, enquiry)
      end
    end

  private

    def add_catering_costs(invoice, enquiry)
      add_catering_line_item(invoice, enquiry)
      add_delivery_line_item(invoice, enquiry)
    end

    def add_catering_line_item(invoice, enquiry)
      event_date = enquiry.event_date.try(:strftime, '%d-%b-%y')
      invoice.add_line_item({
        quantity: 1,
        description: "Catering Costs for Caitre'D Order #{enquiry.id}",
        account_code: '120', # Catering Costs
        unit_amount: enquiry.supplier_food_cost,
        tax_type: 'INPUT'
      })
    end

    def add_delivery_line_item(invoice, enquiry)
      return if enquiry.delivery_cost == 0
      invoice.add_line_item({
        unit_amount: enquiry.supplier_delivery_cost,
        quantity: 1,
        description: 'Delivery',
        account_code: '125',
        tax_type: 'INPUT'
      })
    end

    def branding_theme(enquiry)
      PaymentMethod.find(enquiry.payment_method).xero_template
    end

    # Change this out with suppleir?
    def reference(enquiry)
      "SI-#{enquiry.id})"
    end

    def contact(enquiry)
      food_partner = enquiry.food_partner
      contact = Xero::XeroClient.client.Contact.build(
        name: food_partner.company_name,
        first_name: food_partner.contact_first_name,
        last_name: food_partner.contact_last_name,
        email_address: food_partner.email
      )
      contact.add_address(address(enquiry))
      contact
    end

    def address(enquiry)
      food_partner = enquiry.food_partner
      {
        attention_to: food_partner.company_name,
        address_type: 'POBOX',
        address_line1: food_partner.try(:address_line_1),
        address_line2: food_partner.try(:address_line_2),
        region: food_partner.try(:suburb),
        postal_code: food_partner.try(:postcode),
        country: 'Australia'
      }
    end

  end
end
