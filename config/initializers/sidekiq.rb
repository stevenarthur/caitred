require 'sidekiq'
require 'sidekiq/web'

if Rails.env == 'production' || Rails.env == 'staging'
	Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  		[user, password] == ["Uch3wz", "%psW12dFj"]
	end
end
