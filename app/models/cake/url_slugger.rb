module Cake
  class UrlSlugger < CakeModelModule
    def initialize(klass)
      @klass = klass
    end

    def generate_url_from(property)
      fail(NoMethodError, error_msg) unless @klass.respond_to? :find_by_url_slug
      @klass.include HasUrlSlug
      @klass.class_eval do
        define_method :generate_url_slug do
          generate_url_slug_from send(property).to_s
        end
      end
    end

    def error_msg
      'Can only be included when the find_by_url_slug class method exists'
    end
  end
end
