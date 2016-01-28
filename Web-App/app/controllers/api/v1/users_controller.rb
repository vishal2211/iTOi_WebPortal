class Api::V1::UsersController < Api::V1::BaseController

  before_filter :authenticate_user!, :except => [:create, :reset_password]

  # GET /api/v1/users/me
  def me
    render json: current_user
  end

  # POST/api/v1/users/reset_password
  def reset_password
    addr = params[:email]
    user = User.find_by_email(addr)
    if user.present?
      user.send_reset_password_instructions
      render json: user, status: 200 and return
    else
      render json: {message: "Could not find user with email address #{addr}"}, status: 400 and return
    end
  end

  # POST/api/v1/users/bump_subscription
  def bump_subscription

    # build billing token
    billing_token = params[:token]
    be = BillingEvent.create(user_id: current_user.id, previous_plan_id: current_user.plan_id, new_plan_id: 2, billing_source: BillingEvent::BILLING_SOURCE_IAP, token: billing_token)

    # update plan expiration on user account
    current_user.plan_expiration = current_user.plan_expiration ? current_user.plan_expiration + 30.days : Date.today + 30.days
    current_user.plan_id = 2
    current_user.save

    if be.valid?
      render json: current_user, status: 201 and return
    else
      render json: {message: "Could not create billing record: #{be.errors.full_messages.join(", ")}"}, status: 400 and return
    end

  end

  # POST /api/v1/users
  def create
    existing_user = User.where(email: params[:email])
    if existing_user.length > 0
      render json: {message: "Email address is already taken"}, status: 409 and return
    end

    user = User.create(allowed_attributes)
    #user.company_token = params[:company_token] if params[:company_token]
    if user.valid?
      render json: user, status: 201 and return
    else
      render json: {message: "Could not create user: #{user.errors.full_messages.join(", ")}"}, status: 400 and return
    end
  end

  # PUT /api/v1/users/me
  def update

    has_changes = false

    if params[:plan_id] && params[:plan_id].to_i < 3
      has_changes = true
      current_user.plan_id = params[:plan_id].to_i

      if params[:plan_id].to_i == 2
        current_user.plan_expiration = current_user.plan_expiration ? current_user.plan_expiration + 30.days : Date.today + 30.days
      end

    end

    if has_changes
      current_user.save
      current_user.reload
      render json: current_user, status: 200 and return
    else
      render json: {message: "Nothing to change!"}, status:400 and return
    end

  end

  protected

  def allowed_attributes
    params.permit(:email, :password, :company_token)
  end

end
