namespace :customers do
  desc 'Downcase emails on customers'
  task :downcase_emails => :environment do
    Customer.find_each do |customer|
      customer.email = customer.email.downcase
      customer.save(validate: false)
    end
  end
end

