namespace :production do
  desc "Run all the required tasks to migrate production database correctly."
  task migrate: :environment do

    puts "Extracting Event Date & Time from Enquiries"
    Rake::Task["enquiries:extract_event_date_and_time"].invoke
    puts "Finished Extracting Event Date & Time from Enquiries\n\n"

    puts "Extracting Delivery Hours to new format"
    Rake::Task["delivery_hours:migrate"].invoke
    puts "Finished Extracting Delivery Hours to new format\n\n"

    #   * Import Postcodes
    puts "Updating / Creating Postcodes"
    Rake::Task["postcodes:migrate"].invoke
    puts "Finished Updating / Creating Postcodes\n\n"

    #   * Update FoodPartner Information
    puts "Updating / Creating Food Partner Information"
    Rake::Task["food_partners:migrate"].invoke
    puts "Finished Updating / Creating Food Partner Information\n\n"

    puts "Updating / Creating Menu Categories"
    Rake::Task["menu_categories:migrate"].invoke
    puts "Finished Updating / Creating Menu Categories\n\n"

    puts "Updating / Creating Packageable Items"
    Rake::Task["packageable_items:migrate"].invoke
    puts "Finished Updating / Creating Packageable Items\n\n"

    puts "Updating / Creating Delivery Hours"
    Rake::Task["delivery_hours:migrate"].invoke
    puts "Finished Updating / Creating Delivery Hours\n\n"
    
    if Rails.env.production?
      puts "Creating XERO IDs for packageable items"
      Rake::Task["xero:import_packageable_items"].invoke
      puts "Finished creating XERO IDs for packageable items\n\n"
    else
      puts "Skipping creation of XERO IDS as non-production environment"
    end

  end
end
