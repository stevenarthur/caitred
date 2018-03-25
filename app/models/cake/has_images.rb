module Cake
  class HasImages < CakeModelModule
    def image_properties(*properties)
      @klass.include Asset
      properties.each do |property|
        define_image_method_name
        define_check_for_method
        define_image_file_name?(property)
        define_image_path(property)
        define_image?(property)
      end
    end

    private

    def define_image_method_name
      @klass.class_eval do
        define_method 'image_method_name' do |property|
          "#{property}_image_file_name".to_sym
        end
      end
    end

    def define_check_for_method
      @klass.class_eval do
        define_method 'check_for_image_method' do |property|
          image_method = image_method_name(property)
          error_msg = "Image property #{image_method} must exist as a method on this class"
          fail(NoMethodError, error_msg) unless respond_to? image_method
        end
      end
    end

    def define_image_file_name?(property)
      @klass.class_eval do
        define_method "#{property}_image_file_name?" do
          image_method = image_method_name(property)
          check_for_image_method(property)
          true #!(send(image_method).nil? || send(image_method).empty?)
        end
      end
    end

    def define_image_path(property)
      @klass.class_eval do
        define_method "#{property}_image_path" do
          image_method = image_method_name(property)
          check_for_image_method(property)
          file_name = send("#{property}_image_file_name?")
          return "#{property.to_s.pluralize}/#{send(image_method)}" if file_name
          "#{property.to_s.pluralize}/#{id}.jpg"
        end
      end
    end

    def define_image?(property)
      @klass.class_eval do
        define_method "#{property}_image?" do
          check_for_image_method(property)
          asset_exists? send("#{property}_image_path")
        end
      end
    end
  end
end
