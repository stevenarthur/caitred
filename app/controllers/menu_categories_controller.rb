class MenuCategoriesController < AdminController
  before_action :require_admin_authentication
  before_action :find_food_partner, :set_tab
  before_action :find_menu_category, only: [:edit, :update, :destroy]

  def index
    @menu_categories = @food_partner.menu_categories
  end

  def new
    @menu_category = @food_partner.menu_categories.new
  end

  def create
    @menu_category = @food_partner.menu_categories.new(permitted_params)
    if @menu_category.save
      flash[:success] = "Menu Category created"
      redirect_to edit_menu_category_path(@food_partner, @menu_category)
    else
      flash[:notice] = "Menu Category Failed To Create"
      render :new
    end
  end

  def edit
  end

  def update
    if @menu_category.update_attributes(permitted_params)
      flash[:success] = "Menu Category updated"
      redirect_to edit_menu_category_path(@food_partner, @menu_category)
    else
      flash[:notice] = "Menu Category Failed To Save"
      render :edit
    end
  end

  def destroy
    @menu_category.destroy
    redirect_to menu_categories_path
  end

private
  def find_food_partner
    @food_partner = FoodPartner.find params[:food_partner_id]
  end

  def find_menu_category
    @menu_category = MenuCategory.friendly.find params[:id]
  end

  def set_tab
    @tab = :menu_categories
  end

  def permitted_params
    params.require(:menu_category).permit(:name, :sort_order)
  end


end
