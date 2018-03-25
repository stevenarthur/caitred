module Cake
  class PropertyBase
    extend Cake::Serializable
    extend ActiveModel::Naming

    def self.allowed_property(*properties)
      properties.each do |method_name|
        define_method(method_name) { @properties[method_name] }
      end
    end

    def initialize(params_hash)
      @properties = HashWithIndifferentAccess.new params_hash
    end

    def to_h
      @properties.symbolize_keys
    end
  end
end
