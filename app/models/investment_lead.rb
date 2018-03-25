class InvestmentLead < ActiveRecord::Base
  validates :name, :email, presence: true
end
