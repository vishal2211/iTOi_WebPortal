class UserRecordsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @sort = params[:sort] || "email"
    @sort_dir = params[:sort_dir] || "asc"
    sort_str = "#{@sort} #{@sort_dir}"
    @users = User.all.order(sort_str).paginate(page: params[:page])
    respond_to do |format|
      format.xlsx
      format.html
    end
  end
end