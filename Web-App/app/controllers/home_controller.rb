class HomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    if current_user.is_admin?
      render :admin
    else
      render :index
    end
  end

end