module Factories
  class CustomerFactory
    ALLOWED_PARAMS = [
      :first_name,
      :last_name,
      :email,
      :company_name,
      :telephone,
      :password,
      :additional_first_name,
      :additional_last_name,
      :additional_email,
      :additional_telephone,
      preferences: Preferences.allowed_params
    ]

    # TODO: add methods to create / update customers here
    # and remove from controllers
  end
end
