# encoding: UTF-8

module Authentication
  class AdminUser < ActiveRecord::Base
    acts_as_authentic do |config|
      config.login_field = 'username'
    end

    def self.allowed_properties
      [
        :first_name,
        :last_name,
        :username,
        :password,
        :password_confirmation,
        :email_address,
        :mobile_number,
        :is_power_user
      ]
    end
  end
end
