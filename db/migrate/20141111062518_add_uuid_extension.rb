class AddUuidExtension < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION "uuid-ossp"'
  end
end
