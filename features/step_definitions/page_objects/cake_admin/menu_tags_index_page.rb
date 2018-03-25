module Admin
  class MenuTagsIndexPage < BasePage
    def self.url
      '/admin/menu_tags'
    end

    def generate_tags
      @page.find('#js-generate-menu-tags').click
    end

    def menu_tags_count
      @page.all('.js-menu-tag').size
    end
  end
end
