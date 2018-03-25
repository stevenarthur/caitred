module Admin
  class MenuTagsController < AdminController
    before_action :require_admin_authentication

    def index
      @menu_tags = MenuTag.all
    end

    def generate_tags
      MenuTagGenerator.generate
      redirect_to admin_menu_tags_path
    end

    def save_all
      params[:filters].each do |menu_tag_id|
        menu_tag = MenuTag.find(menu_tag_id.to_i)
        menu_tag.update_attributes!(is_filter: true) unless menu_tag.nil?
      end
      redirect_to admin_menu_tags_path
    end
  end
end
