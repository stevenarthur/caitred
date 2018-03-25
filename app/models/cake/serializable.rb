# encoding: UTF-8

module Cake
  module Serializable
    def dump(serialized_attribute)
      serialized_attribute.to_h
    end

    def load(params_hash)
      new params_hash
    end
  end
end
