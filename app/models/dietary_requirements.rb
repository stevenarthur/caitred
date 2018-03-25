class DietaryRequirements < Cake::PropertyBase
  allowed_property(
    :vegetarian,
    :vegan,
    :gluten_free,
    #:description
  )

  def self.allowed_params
    summary_params.concat [:vegan]
  end

  def summary
    DietaryRequirements.summary_params.map do |property|
      next unless send(property).to_i == 1
      property.to_s.strip.gsub '_', ' '
    end.delete_if(&:blank?).join(', ')
  end

  def self.summary_params
    [
      :vegetarian,
      :vegan,
      :gluten_free
    ]
  end

  def to_s
    "#{@properties['Vegetarian']}, #{@properties['Vegan']}, #{@properties['Gluten Free']}"
  end

  def to_h
    {
      vegetarian: @properties[:vegetarian],
      vegan: @properties[:vegan],
      gluten_free: @properties[:gluten_free],
      #description: @properties[:description]
    }
  end
end
