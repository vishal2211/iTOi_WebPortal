class ExpirationNoticeMailer < ActionMailer::Base
  default from: "no-reply@seeitoi.com"

  def expiration_notice(user)
    mail(to: user.email, subject: "Your See iTOi Subscription Expires in 5 days!")
  end

end
