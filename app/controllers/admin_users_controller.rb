class AdminUsersController < AdminController
  before_action :find_user, only: [:edit, :update, :reset_password]
  before_action :require_power_user, except: [:edit_my_profile, :reset_my_password]
  before_action :require_admin_authentication

  def edit
    @form_type = 'edit_profile'
  end

  def edit_my_profile
    @user = current_user
    @form_type = 'my_profile'
    render template: 'admin_users/edit'
  end

  def reset_my_password
    @user = current_user
    @form_type = 'reset_my_password'
    render template: 'admin_users/reset_password'
  end

  def reset_password
    @form_type = 'reset_password'
  end

  def new
    @user = Authentication::AdminUser.new
  end

  def update
    if @user.update_attributes user_params(params)
      flash[:success] = message(params[:form_type])
      redirect_to path[params[:form_type]]
    else
      render_errors 'edit'
    end
  end

  def message(form_type)
    if form_type.include? 'password'
      'Password reset'
    else
      'Profile updated'
    end
  end

  def index
    @users = Authentication::AdminUser.all
  end

  def destroy
    Authentication::AdminUser.delete params[:id]
    redirect_to users_path
  end

  def create
    return unless power_user?
    @user = Authentication::AdminUser.create user_params(params)
    if @user.errors.empty?
      redirect_to users_path
    else
      render_errors 'new'
    end
  end

  private

  def path
    paths = Hash.new(edit_profile_path)
    paths['reset_my_password'] = reset_my_password_path
    paths['reset_password'] = reset_password_path
    paths['my_profile'] = edit_my_profile_path
    paths
  end

  def find_user
    @user = Authentication::AdminUser.find_by_id params[:id]
  end

  def user_params(params)
    params.require(:authentication_admin_user)
      .permit(*Authentication::AdminUser.allowed_properties)
  end

  def render_errors(template)
    flash[:error] = 'Could not create a new user.'
    render template: "admin_users/#{template}", status: 400
  end
end
