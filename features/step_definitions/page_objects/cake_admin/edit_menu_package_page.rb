module Admin
  class EditMenuPackagePage < BasePage
    def food_items_count
      @page.all('#js-food-items-list tr').count - 1
    end

    def equipment_items_count
      @page.all('#js-equipment-items-list tr').count - 1
    end

    def extra_items_count
      @page.all('#js-extra-items-list tr').count - 1
    end
  end
end
