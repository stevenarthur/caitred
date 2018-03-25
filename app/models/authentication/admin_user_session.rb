module Authentication
  class AdminUserSession < Authlogic::Session::Base
    def to_key
      new_record? ? nil : [send(self.class.primary_key)]
    end

    def persisted?
      false
    end
  end
end
