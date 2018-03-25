module CustomerHelper
  def mailing_list?(customer)
    return 'no' if customer.preferences.opt_out
    'yes'
  end

  def registered?(customer)
    return 'yes' if customer.created_account?
    'no'
  end

  def customer_form_url
    if @customer.id.nil?
      admin_customers_path
    else
      admin_customer_path(@customer)
    end
  end

  def formatted_contact(customer)
    "<div>#{customer.name}</div>
     <div>#{customer.telephone}</div>
     <div>#{customer.email}</div>"
  end
end
