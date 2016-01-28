describe Api::V1::UsersController, :type => :controller do

  before(:each) do
    basic_auth_and_skip_hmac
  end

  context 'GET /api/v1/users/me' do

    context 'with valid credentials' do
      before(:each) do
        get :me, format: :json
        @response = response
        @body = JSON.parse(@response.body)
      end

      it 'returns status 200' do
        expect(response.status).to eq(200)
      end

      it 'has proper email' do
        expect(json['user']['email']).to eq(@user.email)
      end
    end

    it 'returns status 401 on wrong password' do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(@user.email, 'wrong password')
      get :me, format: :json

      expect(response.status).to eq(401)
      expect(json['error']).to eq("Invalid email or password.")
    end

    context 'request user email' do
      it 'should show flag for requesting user email' do
        @company = create(:company, request_user_email: true)
        create(:company_user, user: @user, company: @company)

        get :me, format: :json
        expect(json['user']['company']['request_user_email']).to eq(true)
      end

      it 'should not show true flag is not set' do
        @company = create(:company, request_user_email: false)
        create(:company_user, user: @user, company: @company)

        get :me, format: :json
        expect(json['user']['company']['request_user_email']).to eq(false)
      end
    end

    context 'simplified workflow' do
      it 'should show simplifed flag is set for company' do
        @company = create(:company, simplified_workflow: true)
        create(:company_user, user: @user, company: @company)

        get :me, format: :json
        expect(json['user']['company']['simplified_workflow']).to eq(true)
      end

      it 'should show simplifed flag not set for company' do
        @company = create(:company, simplified_workflow: false)
        create(:company_user, user: @user, company: @company)

        get :me, format: :json
        expect(json['user']['company']['simplified_workflow']).to eq(false)
      end
    end

  end

  context 'POST /api/v1/users' do

    context 'success conditions' do
      it 'creates a new user' do
        my_email = 'david@seeitoi.com'

        post :create, format: :json, email: my_email, password: 'password', company_token: nil
        expect(response.status).to eq(201)
        expect(User.where(email: my_email).count).to eq(1)
      end

      it 'should map a company' do
        my_email = 'david@seeitoi.com'

        @company = create(:company, company_token: 'abcdef')
        post :create, format: :json, email: my_email, password: 'password', company_token: 'abcdef'
        expect(response.status).to eq(201)

        user = User.where(email: my_email).first
        expect(user.company.id).to eq(@company.id)
      end
    end

    context 'failure conditions' do
      it 'rejects creation with existing email' do
        @user = FactoryGirl.create(:user)
        post :create, format: :json, email: @user.email, password: 'pass', company_token: nil

        expect(response.status).to eq(409)

        body = JSON.parse(response.body)
        expect(body['message']).to eq("Email address is already taken")
      end

      it 'rejects creation with short password' do
        @user = FactoryGirl.create(:user)
        post :create, format: :json, email: 'davidtest@itoi.com', password: 'pass', company_token: nil

        expect(response.status).to eq(400)

        body = JSON.parse(response.body)
        expect(body['message']).to eq("Could not create user: Password is too short (minimum is 8 characters)")
      end

      it 'rejects creation with no password' do
        @user = FactoryGirl.create(:user)
        post :create, format: :json, email: 'davidtest@itoi.com'

        expect(response.status).to eq(400)

        body = JSON.parse(response.body)
        expect(body['message']).to eq("Could not create user: Password can't be blank")
      end
    end

  end

  context 'PUT /api/v1/users/1' do
    it 'should updated expiration date' do
      plan = FactoryGirl.create(:plan)
      allow(plan).to receive(:id) {2}
      
      put :update, {id: @user.id, plan_id: plan.id}, format: :json

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['user']['plan']['name']).to eq(plan.name)
      expect(body['user']['plan_expiration']).to eq((@user.plan_expiration + 30.days).strftime("%Y-%m-%d"))
    end

    it 'should not update expiration date if plan id is not equal to 2' do
      plan = FactoryGirl.create(:plan)
      allow(plan).to receive(:id) {1}

      put :update, {id: @user.id, plan_id: plan.id}, format: :json

      expect(response.status).to eq(200)
      body = JSON.parse(response.body)
      expect(body['user']['plan_expiration']).to eq((@user.plan_expiration).strftime("%Y-%m-%d"))
    end

    it 'should do nothing if plan id greater than 3' do
      plan = FactoryGirl.create(:plan)
      allow(plan).to receive(:id) {4}

      put :update, {id: @user.id, plan_id: plan.id}, format: :json

      expect(response.status).to eq(400)
      body = JSON.parse(response.body)
      expect(body['message']).to eq("Nothing to change!")
    end

    it 'should do nothing if plan does not change' do
      put :update, {id: @user.id}, format: :json

      expect(response.status).to eq(400)
      body = JSON.parse(response.body)
      expect(body['message']).to eq("Nothing to change!")
    end
  end

  context 'POST /api/v1/users/reset_password' do

    context 'with valid account' do
      it 'should send password reset email' do
        expect(User).to receive(:find_by_email).with(@user.email).and_return(@user)
        expect(@user).to receive(:send_reset_password_instructions).and_return(true)

        post :reset_password, email: @user.email, format: :json

        expect(response.status).to eq(200)
      end

      it 'should throw error if email does not exist' do
        bad_email = "foo@bar.com"
        expect(User).to receive(:find_by_email).with(bad_email).and_return(nil)

        post :reset_password, email: bad_email, format: :json

        expect(response.status).to eq(400)
        expect(json['message']).to eq("Could not find user with email address #{bad_email}")
      end
    end

  end

  context 'POST /api/v1/users/1/bump_subscription' do
    it 'should upgrade plan' do
      token_value = 'sometoken'
      post :bump_subscription, id: @user.id, token: token_value, format: :json
      body = JSON.parse(response.body)

      expect(body['user']['plan']['name']).to eq('Silver')
      expect(body['user']['plan_expiration']).to eq((@user.plan_expiration + 30.days).strftime("%Y-%m-%d"))

      expect(BillingEvent.count).to eq(1)
      expect(BillingEvent.first.token).to eq(token_value)

      expect(response.status).to eq(201)
    end

    it 'should not upgrade plan', skip_before: true do
      token_value = 'sometoken'
      user =  FactoryGirl.build(:user, password: 'password', password_confirmation: 'password', plan_id: nil)
      allow(controller).to receive(:current_user) { user }

      post :bump_subscription, id: user.id, token: token_value, format: :json

      body = JSON.parse(response.body)
      expect(json['message']).to start_with("Could not create billing record")
    end
  end

end