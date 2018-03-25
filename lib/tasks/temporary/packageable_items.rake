namespace :packageable_items do
  desc "Find / Update Packageable Items"
  task migrate: :environment do
    ActiveRecord::Base.connection.execute(IO.read(Rails.root.join('lib/tasks/temporary/data/packageable_items.sql')))
  end
end
