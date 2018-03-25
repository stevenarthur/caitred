namespace :food_partners do
  desc "Find / Update & Create Food Partner Table."
  task migrate: :environment do
    ActiveRecord::Base.connection.execute(IO.read(Rails.root.join('lib/tasks/temporary/data/food_partners.sql')))
  end
end
