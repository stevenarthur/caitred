class DietaryInfo
  def initialize(menu)
    @menu = menu
  end

  def vegetarian?
    @vegetarian ||= @menu.packageable_items.included.food.all?(&:vegetarian)
  end

  def vegan?
    @vegan ||= @menu.packageable_items.included.food.all?(&:vegan)
  end

  def gluten_free?
    @gluten_free ||= @menu.packageable_items.included.food.all?(&:gluten_free)
  end

  def suitable_for?(dietary)
    suitable_as_is_for?(dietary) ||
      alternatives_for?(dietary)
  end

  def suitable_as_is_for?(dietary)
    @menu.dietary_properties.include?(dietary.name) ||
      @menu.send(dietary.to_method_name)
  end

  def alternatives_for?(dietary)
    @alternatives ||= {}
    @alternatives[dietary] ||=
      @menu.packageable_items.alternatives.send(dietary.to_scope_name).size > 0
  end
end
