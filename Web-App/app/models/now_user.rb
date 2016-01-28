# == Schema Information
#
# Table name: now_users
#
#  id              :integer          not null, primary key
#  email           :string(255)      not null
#  account_type    :string(255)      not null
#  user_pkg        :integer          default(0), not null
#  company_id      :integer          default(0), not null
#  license         :string(255)      not null
#  token           :string(255)      not null
#  tokenExpiration :date             not null
#  expiration      :date             not null
#  purchase_id     :string(255)      not null
#

 #create_table :now_users do |t|
#	    t.string  :email, :null=>false, :unique=>true
#	    t.string  :account_type, :null=>false
#	    t.integer :user_pkg, :default=>0, :null=>false
#	    t.string  :token, :null=>false
#	    t.date    :expiration, :null=>false
#	    t.string  :purchase_id, :null=>false, :unique=>true
#	end


class NowUser < ActiveRecord::Base
	##has_many :company_users
  	has_many :company, :class_name=>"Company", :primary_key=>"id"
  	##has_many :users
  	accepts_nested_attributes_for :company

	def create(params={})
		nowuser = NowUser.new(:email=>params[:email],:company_id=>params[:company_id],:account_type=>params[:account_type],:user_pkg=>params[:user_pkg], :license=>params[:license], :token=>params[:token], :expiration=>params[:expiration], :tokenExpiration=>params[:tokenExpiration], :purchase_id=>params[:purchase_id])
		if nowuser.save
			return true
		else
			return false
		end
	end
	def self.checkParams(params={})
		if NowUser.where(:email=>params[:email]).blank? && params[:accountType] && params[:userPkg] && NowUser.where(:license=>params[:license]).blank? && NowUser.where(:token=>params[:token]).blank? && params[:expiration] && NowUser.where(:purchase_id=>params[:purchaseId]).blank? && !NowUsersAPI.where(:token=>params[:apiKey]).blank?
			return true
		else
			return false
		end
	end
	def self.isUser(params={})
		if params[:token]
			checkUser = NowUser.where(:email=>params[:email], :token=>params[:token]).count
			if checkUser > 0
				return true
			else
				return false
			end
		else
			checkUser = NowUser.where(:email=>params[:email]).count
			if checkUser > 0
				return true
			else
				return false
			end
		end
	end
	## right now just checking against NowUser Table and seeing if license allows for more users. ##
	def self.hasInvites(params={})
		theUser = params
		nowUser = NowUser.where(:email=>params[:email])
		if nowUser.count > 0
			nowUser = nowUser[0].user_pkg

			if theUser.company && theUser.company.users && (theUser.company.users.count - 1  < nowUser)
				return true
			else
				return false
			end
		else
			return false
		end
	end
	def self.getInvites(params={})
		theUser = params
		nowUser = NowUser.where(:email=>params[:email])[0]
		return nowUser.user_pkg - theUser.company.users.count - 1
	end
	def self.expired(params={})
		theUser = NowUser.where(:email=>params[:email])

		if theUser.count > 0 && Time.now < theUser[0].expiration
			return false
		else
			return true
		end
	end
	def self.addCompany(params={})
		addcompanyuser = NowUser.find_by_email_and_token(params[:email], params[:token]);
		if addcompanyuser.account_type == 'MULTI'
			addcompanyuser.company_id = params[:companyId]
			if addcompanyuser.save
				return true
			else
				return false
			end
		else
			return false
		end
	end
	def self.generateToken
		token = Digest::SHA1.hexdigest([Time.now, rand].join)[0..25]
		if !Company.where(:company_token=>token).blank?
			NowUser.generateToken
		else
			return token
		end
	end
end
