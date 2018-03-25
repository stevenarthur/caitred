class Web::EnquiryItemsController < WebsiteController
  before_action :find_enquiry

  def create
    clear_other_vendors_order(permitted_params)
    find_or_add_to_quantity(permitted_params)
    @enquiry.customer = current_customer if current_customer.present?
    @enquiry.populate_from_enquiry_items
    @food_partner = @enquiry.food_partner
    @enquiry.save
    session[:enquiry_id] = @enquiry.id
  end

  def update
    @enquiry.customer = current_customer if current_customer.present?
    @enquiry_item = @enquiry.enquiry_items.find(params[:id])
    @enquiry_item.update_attributes
    @food_partner = @enquiry.food_partner
    @enquiry.populate_from_enquiry_items
    @enquiry.save
  end

  def destroy
    @enquiry_item = @enquiry.enquiry_items.find(params[:id])
    @enquiry_item.destroy
    @enquiry.populate_from_enquiry_items
    @enquiry.save
    @food_partner = @enquiry.food_partner
    session.delete(:enquiry_id) if !@enquiry.enquiry_items.present?
  end

  def clear
    @enquiry.enquiry_items.destroy_all
    @enquiry.customer = current_customer if current_customer.present?
    @enquiry.food_partner = nil
    @enquiry.populate_from_enquiry_items
    @enquiry.save!
    redirect_to request.referer
  end

  def add_package
    if minimum_order_is_met
      add_or_update_each_item_to_cart
      @enquiry.customer = current_customer if current_customer.present?
      @enquiry.populate_from_enquiry_items
      @food_partner = @enquiry.food_partner
      @enquiry.save
      session[:enquiry_id] = @enquiry.id
    else
      @enquiry.errors[:base] << "The minimum order of #{minimum_order} has not been met"
    end
  end

  def remove_package
    item = EnquiryItem.find(params[:id])
    existing_item_ids = [item.id]
    existing_item_ids << item.package_subitems.pluck(:id)
    existing_items = EnquiryItem.where(id: existing_item_ids.flatten).destroy_all
    @enquiry.customer = current_customer if current_customer.present?
    @enquiry.populate_from_enquiry_items
    @enquiry.save!
    @food_partner = @enquiry.food_partner
    session.delete(:enquiry_id) if !@enquiry.enquiry_items.present?
  end

private
  def find_or_add_to_quantity(permitted_params)
    item_id = permitted_params[:packageable_item_id]
    if @enquiry.enquiry_items.find_by(packageable_item_id: item_id)
      @enquiry_item = @enquiry.enquiry_items.find_by(packageable_item_id: item_id)
      @enquiry_item.quantity = @enquiry_item.quantity.to_i + permitted_params[:quantity].to_i
      @enquiry_item.additional_instructions = permitted_params[:additional_instructions] if permitted_params[:additional_instructions].present?
      @enquiry_item.save
    else
      @enquiry_item = @enquiry.enquiry_items.new(permitted_params)
    end
  end

  def clear_other_vendors_order(permitted_params)
    if item = PackageableItem.find(permitted_params[:packageable_item_id])
      if item.food_partner_id != @enquiry.food_partner_id
        @enquiry.enquiry_items.destroy_all
        @enquiry.food_partner = nil
        @enquiry.populate_from_enquiry_items
        @enquiry.save!
      end
    end
  end

  def minimum_order_is_met
    base_item = package_params[:standard_item]
    variants = package_params[:variants]

    parent_package = PackageableItem.find(base_item["packageable_item_id"])
    minimum_order = parent_package.minimum_order

    parent_quantity = base_item["quantity"].to_i
    variants_quantity = variants.present? ? variants.map { |v| v["quantity"].to_i }.sum : 1

    minimum_order <= (parent_quantity + variants_quantity)
  end

  def minimum_order
    base_item = package_params[:standard_item]
    parent_package = PackageableItem.find(base_item["packageable_item_id"])
    parent_package.minimum_order
  end

  def add_or_update_each_item_to_cart
    base_item = package_params[:standard_item]
    variants = package_params[:variants]

    remove_existing_items(base_item, variants)

    @enquiry.enquiry_items.new(base_item) if base_item["quantity"] != ("0" || 0)
    if variants.present?
      variants.reject{ |v| v["quantity"] == ("0" || 0) }.each do |variant|
        @enquiry.enquiry_items.new(variant)
      end
    end

    if package_params[:additional_instructions].present?
      @enquiry.enquiry_items.each do |i|
        i.additional_instructions = package_params[:additional_instructions] if !i.persisted?
      end
    end

    @enquiry.save
  end

  def remove_existing_items(base_item, variants)
    existing_item_ids = [ base_item["packageable_item_id"] ]
    variants.each{ |v| existing_item_ids << v["packageable_item_id"] } if variants.present?
    existing_items = @enquiry.enquiry_items.where(packageable_item_id: existing_item_ids).destroy_all
  end

  def find_enquiry
    @enquiry = current_enquiry
  end

  def permitted_params
    params.require(:enquiry_item).permit(:quantity, :packageable_item_id, :additional_instructions)
  end

  def package_params
    params.require(:package_items).permit(:additional_instructions, 
                                          standard_item: [:quantity, :packageable_item_id],
                                          variants: [:quantity, :packageable_item_id])
  end
end
