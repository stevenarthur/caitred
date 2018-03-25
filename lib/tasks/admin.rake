namespace :admin do
  desc 'Create admin user'
  task :new_dev_admin, [:username, :password] => [:environment] do |t, args|
    user_params = args.to_h.merge({
      first_name: args[:username],
      last_name: args[:username],
      password_confirmation: args[:password],
      email_address: "#{args[:username]}@test.com",
      mobile_number: '0123456789',
      is_power_user: false
    })
    user = Authentication::AdminUser.create(user_params)
  end
end
