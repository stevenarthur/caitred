class SpecialDiets
  include Comparable

  attr_reader :name, :group_name

  def initialize(special_diet, group_name)
    @name = special_diet
    @group_name = group_name
  end

  def self.names
    SPECIAL_DIETS.map(&:name)
  end

  def self.all
    SPECIAL_DIETS
  end

  def self.find(name)
    return nil if name.nil?
    SPECIAL_DIETS.find do |diet|
      name.downcase == diet.name.downcase
    end
  end

  def self.find_by_slug(name)
    return nil if name.nil?
    SPECIAL_DIETS.find do |diet|
      name.downcase == diet.name.downcase.gsub(' ', '-')
    end
  end

  def to_method_name
    "#{name.downcase.gsub(' ', '_')}?"
  end

  def to_scope_name
    name.downcase.gsub(' ', '_')
  end

  def slug
    name.downcase.gsub(' ', '-')
  end

  def <=>(other)
    name <=> other.name
  end

  SPECIAL_DIETS = [
    SpecialDiets.new('Vegetarian', 'vegetarians'),
    SpecialDiets.new('Vegan', 'vegans'),
    SpecialDiets.new('Gluten Free', 'people who do not eat gluten')
  ]
end
