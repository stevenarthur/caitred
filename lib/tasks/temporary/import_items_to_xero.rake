namespace :xero do
  desc 'Import Packageable Items into Xero'
  task :import_packageable_items => :environment do

    PackageableItem.where(xero_item_id: nil).each do |packageable_item|

      xero_item = Xero::XeroClient.client.Item.build(
                    code: "#{packageable_item.food_partner.id}-#{packageable_item.id}", 
                    description: packageable_item.title, 
                    :sales_details => { :unit_price => packageable_item.cost, 
                                        :tax_type => 'OUTPUT', 
                                        :account_code => "200" })
      xero_item.save
      packageable_item.update_attributes(xero_item_id: xero_item.id)

    end

    #item_array = []
    #PackageableItem.all.each_with_index do |item, index|
      #item_array << Xero::XeroClient.client.Item.build(code: "#{item.food_partner.id}-#{item.id}", 
                                                       #description: item.title, 
                                                       #:sales_details => { 
                                                          #:unit_price => item.cost, 
                                                          #:tax_type => 'OUTPUT', 
                                                          #:account_code => "200" 
                                                       #})
    #end
    #Xero::XeroClient.client.Item.save_records(item_array)
    #
  
    #into job.
    #Xero::XeroClient.client.Item.all(where: { code: "#{item.food_partner.id}-#{item.id}" })

    #items = Xero::XeroClient.client.Item.all
    #items = items.select{ |i| i.code.include?("-") }

    #items.each do |xero_invoice| 
      #item_id = xero_invoice.code.split("-")[1]
      #item = PackageableItem.find_by(id: item_id)
      #if item.present?
        #item.update_attributes(xero_item_id: xero_invoice.item_id)
      #end
    #end

  end
end
