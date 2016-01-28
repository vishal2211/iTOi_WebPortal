class NowRelayMailer < ActionMailer::Base
	default from: "no-reply@seeitoi.com"
	def reset_token_email(email)
		@email = email
		@token = NowUser.generateToken

		mail(to: @email, subject: 'See iTOi - User Setup Token Reset')
	end
end