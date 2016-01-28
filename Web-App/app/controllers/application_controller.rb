class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  rescue_from CanCan::AccessDenied do |exception|
    render :text => 'Unauthorized', :status => 401, :layout => false
  end

  protected

  def layout_by_resource
    if devise_controller?
      "unauthorized"
    else
      "application"
    end
  end

  def admin_users
    current_user.is_admin?
  end

end
