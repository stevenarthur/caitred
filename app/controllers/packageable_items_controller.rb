class PackageableItemsController < AdminController
  before_action :require_admin_authentication
  before_action :find_food_partner, :set_tab
  before_action :find_packageable_item, only: [:edit, :update, :destroy]
  before_action :get_available_items, only: [:new, :edit]
  before_action :find_menu_categories, only: [:new, :edit]

  def index
    @packageable_items = PackageableItem.by_food_partner(@food_partner).by_sort_order
  end

  def new
    @packageable_item = PackageableItem.new
  end

  def edit
  end

  def update
    @packageable_item.update_attributes! packageable_item_params
    update_xero_item if Rails.env.production? 
    flash[:success] = 'Packageable Item updated'
    redirect_to edit_packageable_item_path(food_partner: @food_partner, id: @packageable_item)
  end

  def create
    @packageable_item = PackageableItem.create! packageable_item_params
    create_xero_item if Rails.env.production?
    flash[:success] = 'Packageable Item created'
    redirect_to packageable_items_path @food_partner
  end

  def destroy
    @packageable_item.destroy
    flash[:warning] = 'Packageable Item deleted'
    redirect_to packageable_items_path @food_partner
  end

private
  def create_xero_item
    item = Xero::XeroClient.client.Item.build(code: "#{@packageable_item.food_partner.id}-#{@packageable_item.id}", 
                                              description: @packageable_item.title, 
                                              :sales_details => { :unit_price => @packageable_item.cost, :tax_type => 'OUTPUT', :account_code => "200" })
    item.save
    @packageable_item.update_attributes(xero_item_id: item.id)
  end

  def update_xero_item
    item = Xero::XeroClient.client.Item.find(@packageable_item.xero_item_id)
    item.sales_details.unit_price = @packageable_item.cost
    item.description = @packageable_item.title
    item.save
  end

  def find_food_partner
    @food_partner = FoodPartner.find params[:food_partner_id]
  end

  def set_tab
    @tab = :packageable_items
  end

  def packageable_item_params
    p = params.require(:packageable_item).permit(*PackageableItem.allowed_params)
    p.merge food_partner: @food_partner
  end

  def get_available_items
    @available_items = @food_partner.packageable_items.where(parent_id: nil)
  end

  def find_menu_categories
    @menu_categories = @food_partner.menu_categories
  end

  def find_packageable_item
    @packageable_item = PackageableItem.find params[:id]
  end
end
