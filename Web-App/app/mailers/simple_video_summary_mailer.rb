class SimpleVideoSummaryMailer < ActionMailer::Base
  default from: "no-reply@seeitoi.com"

  def notify_of_project(recording)
    @recording = recording
    mail(to: recording.user.email, subject: "Your See iTOi Video")
  end

end
