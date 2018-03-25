# encoding: UTF-8

class Logistics < Cake::PropertyBase
  allowed_property(
    :parking_information
  )

  def self.allowed_params
    [
      :parking_information
    ]
  end
end
