class Address < ActiveRecord::Base
  belongs_to :customer
  validates :company, presence: true
  validates :line_1, presence:  true
  validates :suburb, presence: true
  validates :postcode, presence: true
  validates :parking_information, presence: true

  def self.allowed_params
    [
      :company,
      :line_1,
      :line_2,
      :suburb,
      :postcode,
      :parking_information
    ]
  end

  def one_line
    [company, line_1, line_2, suburb, postcode].delete_if(&:blank?).join(', ')
  end
end
