class AccountsController< ActionController::Base
  before_filter :authenticate_user!
  layout 'application'

  # AKA "me"
  def show
  end

  def password
  end

  def update_password

    if !current_user.valid_password?(params[:user][:current_password])
      current_user.errors.add(:current_password, 'Current password is wrong')
    end

    if params[:user][:password] != params[:user][:password_confirmation]
      current_user.errors.add(:password_confirmation, 'Password confirmation does not match')
    end

    allowed = params.required(:user).permit(:password, :password_confirmation)
    if current_user.errors.count == 0 && current_user.update(allowed)
      sign_in current_user, :bypass => true
      redirect_to account_path, notice: 'Password updated!'
    else
      render "password"
    end
  end

end
