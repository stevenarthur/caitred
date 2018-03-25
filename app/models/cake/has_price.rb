module Cake
  module HasPrice
    include Money

    def free?
      price.nil? || price.to_d.zero?
    end
  end
end
