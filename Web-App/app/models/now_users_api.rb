# == Schema Information
#
# Table name: now_users_apis
#
#  id    :integer          not null, primary key
#  name  :string(255)      not null
#  token :string(255)      not null
#

class NowUsersAPI < ActiveRecord::Base
	def create(params={})
		if params[:name]
			if NowUsersAPI.where(:name=>params[:name]).blank?
				@thenowuserapi = NowUsersAPI.new
				@thenowuserapi.name = params[:name]
				@thenowuserapi.token = @thenowuserapi.generateToken
				if @thenowuserapi.save
					return true
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
	end
	def generateToken
		@token = Digest::SHA1.hexdigest([Time.now, rand].join)[0..25]
		if !NowUsersAPI.where(:token=>@token).blank?
			generateToken
		else
			return @token
		end
	end
end
