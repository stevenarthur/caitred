namespace :postcodes do
  desc "Find / Update & Create Postcodes."

  task migrate: :environment do
    ActiveRecord::Base.connection.execute(IO.read(Rails.root.join('lib/tasks/temporary/data/postcodes.sql')))
  end

end
