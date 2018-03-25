module TagParams
  class Reader
    def initialize(params, validator = Validator.new)
      @params = params.clone
      @validator = validator
    end

    def event_type
      return nil unless primary_tag
      @event_type ||= @validator.event_type(primary_tag)
    end

    def diets
      [
        @validator.diet(primary_tag)
      ].concat(diets_from_other_tags)
        .delete_if(&:nil?)
    end

    def menu_tags
      [
        @validator.menu_tag(primary_tag)
      ].concat(menu_tags_from_other_tags)
        .delete_if(&:nil?)
    end

    def add_tag(tag)
      @params[:tags] = (other_tags << tag).join(',')
      self
    end

    def remove_tag(tag)
      @params[:first_tag] = nil if primary_tag == tag
      @params[:tags] = other_tags.delete_if do |other_tag|
        other_tag == tag
      end.join(',')
      self
    end

    def includes_tag?(tag)
      primary_tag == tag || other_tags.include?(tag)
    end

    private

    def diets_from_other_tags
      other_tags.map do |tag|
        @validator.diet(tag)
      end
    end

    def menu_tags_from_other_tags
      other_tags.map do |tag|
        @validator.menu_tag(tag)
      end
    end

    def primary_tag
      @params[:first_tag]
    end

    def other_tags
      @params[:tags].to_s.split(',')
    end
  end
end
