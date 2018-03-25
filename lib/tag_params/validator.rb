module TagParams
  class Validator
    def event_type(tag)
      EventTypes.find(tag)
    end

    def diet(tag)
      SpecialDiets.find_by_slug(tag)
    end

    def menu_tag(tag_param)
      valid_menu_tags.find do |menu_tag|
        menu_tag.tag == tag_param
      end
    end

    def valid_menu_tags
      @valid_menu_tags ||= MenuTag.filters
    end
  end
end
