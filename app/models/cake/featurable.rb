module Cake
  class Featurable < CakeModelModule
    def featurable
      @klass.include Taggable
      @klass.define_singleton_method :featured do |limit|
        results = with_tag('featured')
        filtered = yield results if block_given?
        filtered.take(limit)
      end
    end
  end
end
