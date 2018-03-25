Judge.configure do
  expose Authentication::AdminUser, :username, :email_address
  expose Customer, :email, :additional_email
end

##Judge.config.exposed[Customer] = [:email, :additional_email]
##Judge.config.exposed[Customer] = [:email]

