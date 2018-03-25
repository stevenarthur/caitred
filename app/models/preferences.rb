class Preferences < Cake::PropertyBase
  allowed_property :opt_out, :communication_method

  def self.allowed_params
    [:opt_out, :communication_method]
  end

  def opt_out
    @properties[:opt_out].to_i == 1
  end
end
