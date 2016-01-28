class NowrelayController < ApplicationController
	respond_to :html, :json
	layout 'nowcoders'
	after_filter :set_access_control_headers
	skip_before_filter :verify_authenticity_token, :only => [:addAuth, :checkUser, :cancelUser]

	def index
		if params[:email] && params[:token]
			@userEmail = String.new(params[:email])
			@userToken = String.new(params[:token])
			@retPart = 'setupUser'
		else
			@retPart = 'relayError'
		end
	end

	def set_access_control_headers
    	headers['Access-Control-Allow-Origin'] = "*"
    	headers['Access-Control-Request-Method'] = "*"
  	end

	def addAuth
		if NowUsersAPI.where(:token=>params[:apiKey]).count > 0
			@userEmail = String.new(params[:email])
			@userAcctType = String.new(params[:accountType])
			@userPkg = String.new(params[:userPkg])
			@userLicense = String.new(params[:license])
			@userToken = String.new(params[:token])
			@userExpiration = String.new(params[:expiration]).to_date
			@userTokenExp = String.new(params[:expiration]).to_date
			@userPId = String.new(params[:purchaseId])
			if !NowUser.isUser(:email=>params[:email])
				if Time.now < @userExpiration
					if NowUser.create(:email=>@userEmail, :account_type=>@userAcctType, :user_pkg=>@userPkg, :license=>@userLicense, :token=> @userToken, :expiration=>@userExpiration, :tokenExpiration=>@userTokenExp, :purchase_id=>@userPId)
						redirect_to root_path, :status => 200
						##flash[:notice]= 'user was successfully created.'
					else
						##flash[:notice]= 'exists'
						render(:file => File.join(Rails.root, 'public/422.html'), :status => 422, :responeText => 'user exists or there was a problem with parameters')
					end
				end
			elsif NowUser.isUser(:email=>params[:email]) && params.count > 2
				flash[:notice]= 'now user found'
				nowUser = NowUser.where(:email=>params[:email])
				if nowUser.update_all :email=>@userEmail, :account_type=>@userAcctType, :user_pkg=>@userPkg, :license=>@userLicense, :token=> @userToken, :expiration=>@userExpiration, :tokenExpiration=>@userTokenExp, :purchase_id=>@userPId
					flash[:notice] = 'now user updated'
				end
			end
		else
			render(:file => File.join(Rails.root, 'public/422.html'), :status => 422, :responeText => 'issues')
		end
	end
	def checkUser
		respond_to do |format|
			if NowUser.where(:email=>params[:email]).count > 0 && NowUsersAPI.where(:token=>params[:apiKey]).count > 0 && User.where(:email=>params[:email]).count > 0
				format.json { render :json =>{ :status=>200, :responseText=>'success' }, :status=>200 }
			else
				format.json { render :json =>{ :status=>422, :responseText=>'error', :email=>params[:email], :token=>params[:apiKey], :nowusercheck=>NowUser.where(:email=>params[:email]).count, :apiCheck=> NowUsersAPI.where(:token=>params[:apiKey]).count, :usercheck => User.where(:email=>params[:email]).count }, :status=>422 }
			end
		end
	end
	def cancelUser
		respond_to do |format|
			if NowUser.where(:email=>params[:email], :license=>params[:license]).count > 0 && NowUsersAPI.where(:token=>params[:apiKey]).count > 0
				theNowUser = NowUser.where(:email=>params[:email])[0]
				theNowUser.expiration = Time.now
				theUser = User.where(:email=>params[:email])[0]
				theUser.plan_expiration = Time.now
				if theUser.save && theNowUser.save
					format.json { render :json =>{ :status=>200, :responseText=>'success' }, :status=>200 }
				else
					format.json { render :json => {:status=>422, :responseText=>'error'}, :status=>422 }
				end
			else
				format.json { render :json =>{ :status=>422, :responseText=>'error' }, :status=>422 }
			end
		end
	end
	def resendAuth
		NowRelayMailer.reset_token_email(params[:email]).deliver
	end
	def getStart
		@nowrelay = NowUser.new(now_params)
		@expiration = NowUsers.where(:email=>@nowrelay.email, :token=>@nowrelay.token)
	end
	def company
		@nowrelay = NowUser.new(now_params)
		@company = Company.new
	end
	def createCompanyUser
		@nowCompanyUser = CompanyUser.new
		user_params = {:email=>params[:company_user][:email],:password=>params[:company_user][:password], :password_confirmation=>params[:company_user][:password_confirmation]}
		if User.where(:email=>user_params[:email]).count == 0
			@itoiUser = User.new(user_params)
			@itoiUser.plan_id = 4
			@itoiUser.save
			companyToken = params[:company_user][:company_token]
			userEmail = params[:company_user][:email]
			user = User.where(:email=>userEmail)[0]
			if CompanyUser.where(:user_id=>user.id).count == 0
				company = Company.where(:company_token=>companyToken)[0]
				@nowCompanyUser.user_id = user.id
				@nowCompanyUser.company_id = company.id
				@nowCompanyUser.permissions = 1
				if !@nowCompanyUser.save
					flash[:notice]= 'NowRelay Error - User was not created.  Please try following the link in your email again.  If that continues not to work, please reach out to our dedicated support team at 1-844-SEE-iTOi.'
				else
					flash[:notice] = 'Group Account and Admin User Created Successfully!  Please login.'
					redirect_to new_user_session_path and return
				end
			end
		end
		redirect_to new_user_registration_path
	end
	def createCompany
		@company = Company.new(now_params[:company])
		@nowrelay = NowUser.new(now_params.except(:company))
			@company.company_token = NowUser.generateToken
			if NowUser.where(:email=>@nowrelay.email, :token=>@nowrelay.token).count > 0
				if @company.save
					#redirect_to '#{new_registration_path}?email=#{params[:email]}&token=#{params[:token]&company=#{@company.company_token}'
					flash[:notice]= 'Group was successfully created.'
					NowUser.addCompany(:email=>@nowrelay.email, :token=>@nowrelay.token, :companyId=>@company.id)
					respond_with(@company, @nowrelay)
					##format.html { redirect_to '#{new_registration_path}?email=#{params[:email]}&token=#{params[:token]&company=#{@company.company_token}', notice: 'Group was successfully created.' }
					##format.json { render json: @company, status: :created }
				else
					flash[:notice]= 'Group was not created.-NowUser matched'
					respond_with(@company,@nowrelay)
				end
			else ##NowUser.where(:email=>params[:email], :token=>params[:token]).count <= 0 && company_params
				flash[:notice]= 'Group was not created - NowUser not matched.'
				redirect_to relay_company_path
			end
	end
    def now_params
    	return params.require(:now_user).permit(:email,:token, :company=>[:name, :plan_id, :whitelabel_text, :whitelabel_icon_url, :watermark_image_url, :header_image_url, :footer_image_url, :company_logo_url, :default_plan_id, :contract_start_date, :contract_end_date, :allow_uploads])
    end
end