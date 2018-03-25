class EventTypes
  attr_reader :name

  def initialize(event_type)
    @name = event_type
  end

  def slug
    name.downcase.gsub(' ', '-')
  end

  def self.names
    EVENT_TYPES.map(&:name)
  end

  def self.all
    EVENT_TYPES
  end

  def self.find(param_string)
    EVENT_TYPES.find do |type|
      type.slug == param_string.downcase
    end
  end

  def self.find_by_name(param_string)
    EVENT_TYPES.find do |type|
      type.name.downcase == param_string.downcase
    end
  end

  def self.map_to_types(arr)
    EVENT_TYPES.map do |type|
      [type, arr.select { |item| item.event_type.include? type.name }]
    end.to_h
  end

  EVENT_TYPES = [
    EventTypes.new('Breakfast'),
    EventTypes.new('Lunch'),
    EventTypes.new('Dinner'),
    EventTypes.new('Finger Food'),
    EventTypes.new('Canapes'),
    EventTypes.new('Morning Tea'),
    EventTypes.new('Afternoon Tea'),
    EventTypes.new('Dessert'),
    EventTypes.new('Packages'),
    EventTypes.new('Beverages')
  ]
end
