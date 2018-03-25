module Admin
  class PackageableItemsIndexPage < BasePage
    def self.for_food_partner(food_partner_name)
      food_partner = FoodPartner.find_by_company_name(food_partner_name)
      "/admin/food_partners/#{food_partner.id}/packageable_items"
    end

    def item_count
      @page.all('.js-item').size
    end

    def add_item
      @page.find('#js-add-item').click
    end

    def edit_item(title)
      id = PackageableItem.find_by_title(title).id
      @page.find(".js-edit-item[data-itemid='#{id}']").click
    end

    def delete_item(title)
      id = PackageableItem.find_by_title(title).id
      @page.find(".js-delete-item[data-itemid='#{id}']").click
    end
  end
end
