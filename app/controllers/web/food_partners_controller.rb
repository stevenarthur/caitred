module Web
  class FoodPartnersController < WebsiteController
    layout 'website'

    ## Critical bug where the session isn't accounted for on index.
    def index
      @food_partners = FoodPartner.active
    end

    def show
      @food_partner = FoodPartner.includes(menu_categories: :packageable_items).find_by_url_slug(params[:slug])
      @top_level_packages = PackageableItem.includes(:subitems)
                                           .where(food_partner_id: @food_partner.id).active_top_level_packages
      not_found unless @food_partner.active?
    end

    def information
      @food_partner = FoodPartner.find_by_url_slug(params[:slug])
    end

    private
      def not_found
        raise ActionController::RoutingError.new('Not Found')
      end

  end
end
