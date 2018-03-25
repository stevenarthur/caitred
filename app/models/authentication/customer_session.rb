module Authentication
  class CustomerSession < Authlogic::Session::Base
    authenticate_with Customer
    logout_on_timeout true

    def to_key
      new_record? ? nil : [send(self.class.primary_key)]
    end

    def persisted?
      false
    end
  end
end
