class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_company

  def index
    @users = CompanyUser.where(company_id: @company.id).reject{|c| !c.user.active?}.collect {|c| c.user }
  end

  def invite
    email = params[:email]

    if email.blank?
      redirect_to company_users_path(@company), :notice => "You must specify an email"
      return
    end

    existing_user = User.find_by_email(email)

    plan_id = @company.default_plan_id || 1

    if existing_user && existing_user.has_access?(@company)
      flash[:notice] = "User already exists!"
      redirect_to company_users_path(@company) and return
    elsif existing_user && existing_user.company
      flash[:notice] = "User has an account and is already part of another company, cannot add"
      redirect_to company_users_path(@company) and return
    elsif existing_user
      flash[:notice] = "User already had an account and has been added to this company"
      CompanyUser.create(:company_id => @company.id, :user_id => existing_user.id, :permissions => 0)
      redirect_to company_users_path(@company) and return
    else
      flash[:notice] = "An invitation has been emailed to #{email}"
      new_user = User.invite!({:email =>email, :plan_id => plan_id}, current_user)
      CompanyUser.create(:company_id => @company.id, :user_id => new_user.id, :permissions => 0)
      redirect_to company_users_path(@company) and return
    end

  end

  def manual_create
    email = params[:email]
    password = params[:password]
    existing_user = User.find_by_email(email)

    plan_id = @company.default_plan_id || 1

    if existing_user && existing_user.has_access?(@company)
      redirect_to company_users_path(@company), :alert => "User already exists!" and return
    elsif existing_user
      CompanyUser.create(:company_id => @company.id, :user_id => existing_user.id, :permissions => 0)
      redirect_to company_users_path(@company), :notice => "User already had an account and has been added to this cp,[amy" and return
    else
      new_user = User.new({:email => email, :plan_id => plan_id, :password => password, :password_confirmation => password, :invitation_accepted_at => Time.now, :invited_by_id => current_user.id, :invited_by_type => "User"})
      if new_user.save
        CompanyUser.create(:company_id => @company.id, :user_id => new_user.id, :permissions => 0)
        redirect_to company_users_path(@company), :notice => "#{email} has been created" and return
      else
        redirect_to company_users_path(@company), :alert => new_user.errors.full_messages.join(", ")
      end
    end

  end


  def edit
    @user = User.find(params[:id])

  end

  def show
    @user = User.find(params[:id])
    @recordings = @user.recordings.active

    params[:order] ||= "-created_at"
    if ['-created_at', '+created_at', '+title', '+created_by'].include? params[:order]
      order_dir = (params[:order][0] == "-") ? "desc" : "asc"
      order_string = params[:order][1..-1]
      if order_string == "created_by"
        order_string = "email"
      end
      @recordings = @recordings.order("#{order_string} #{order_dir}")
    end


  end

  def update

    @user = User.find(params[:id])

    permission = params[:permission]
    cu = @user.company_user
    cu.permissions = permission
    cu.save

    if current_user.is_admin? && params[:user] && params[:user][:plan_id]
      permitted = params[:user].permit(:plan_id)
      @user.update_attributes(permitted)
    end

    redirect_to company_users_path(@company)

  end

  def destroy

    @user = User.find(params[:id])

    CompanyUser.where(user: @user, company: @company).destroy_all

    respond_to do |format|
      format.html { redirect_to company_users_path(@company) }
      format.json { head :no_content }
    end
  end

  private

  def load_company
    @company = Company.find(params[:company_id]) if params[:company_id]
  end

end