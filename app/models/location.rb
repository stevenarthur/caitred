class Location
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def slug
    @name.downcase
  end

  def self.find_by_slug(param)
    result = LOCATIONS.find { |_key, location| location.slug == param }
    return sydney if result.nil?
    result[1]
  end

  LOCATIONS = {
    sydney: Location.new('Sydney'),
    melbourne: Location.new('Melbourne')
  }

  def self.sydney
    LOCATIONS[:sydney]
  end
end
