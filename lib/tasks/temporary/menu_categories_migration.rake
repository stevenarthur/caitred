namespace :menu_categories do
  desc "Find / Update Menu Categories Table."
  task migrate: :environment do
    ActiveRecord::Base.connection.execute(IO.read(Rails.root.join('lib/tasks/temporary/data/menu_categories.sql')))
  end
end
