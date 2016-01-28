require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    @user = create(:user_with_recordings)
    @company = @user.company
    sign_in @user
  end

  describe 'GET /companies/X/users' do

    it "should list user" do
      get :index, {company_id: @company.id}
      expect(assigns(:users)).to eq([@user])
    end

    it "should not list inactive user" do

      @inactive_user = create(:user, status: User::STATUS_DELETED)
      CompanyUser.create(company_id: @user.id, user_id: @inactive_user.id)

      get :index, {company_id: @company.id}
      expect(assigns(:users)).to eq([@user])
    end

  end

  describe 'GET /companies/X/users/Y' do

    it 'should assign user' do
      get :show, {company_id: @company.id, id: @user.id}
      expect(assigns(:user)).to eq(@user)
    end

  end

end
