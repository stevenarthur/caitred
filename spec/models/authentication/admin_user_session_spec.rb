require 'rails_helper'
require 'authlogic/test_case'

module Authentication
  describe AdminUserSession do
    include Authlogic::TestCase

    setup :activate_authlogic

    describe '#persisted?' do
      let(:user) { create(:admin_user) }
      let(:session) do
        AdminUserSession.create!(
          username: user.username,
          password: user.password
        )
      end

      it 'is always false' do
        expect(session.persisted?).to be false
      end

    end

  end
end
