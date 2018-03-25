class AdminUserSessionsController < AdminController
  def new
    @user_session = Authentication::AdminUserSession.new
  end

  def create
    user_params = user_session_params(params)
    @user_session = Authentication::AdminUserSession.new user_params
    begin
      @user_session.save!
      redirect_to admin_enquiries_path
    rescue
      flash[:error] = 'Login failed, please try again.'
      redirect_to login_path
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path
  end

  private

  def user_session_params(params)
    params.require(:authentication_admin_user_session).permit(:username, :password)
  end
end
