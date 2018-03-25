module CakeModel
  extend ActiveSupport::Concern

  included do
    def self.cake_model(&block)
      Evaluator.new(self).instance_eval(&block)
    end
  end

  class Evaluator < Cake::CakeModelModule
    def generate_url_from(*args)
      Cake::UrlSlugger.new(@klass).generate_url_from(*args)
    end

    def featurable(&block)
      Cake::Featurable.new(@klass).featurable(&block)
    end

    def image_properties(*args)
      Cake::HasImages.new(@klass).image_properties(*args)
    end
  end
end
