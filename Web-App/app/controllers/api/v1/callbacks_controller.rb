class Api::V1::CallbacksController < Api::V1::BaseController

  # these are SNS topic callbacks from Elastic Transcoder
  def fail
    Rails.logger.info "Got SNS Failure"
    Rails.logger.info params.to_json
    req_body = JSON.parse(request.body.read)
    Rails.logger.info req_body.to_json
    msg_obj = JSON.parse(req_body['Message'])
    job_id = msg_obj['jobId']
    recording = Recording.where(transcoder_job_id: job_id).first
    if recording
      recording.transcoder_error_message = msg_obj['messageDetails']
      recording.save
    end
    render :json => {}, :status => :ok
  end

  def success
    Rails.logger.info "Got SNS Success"
    Rails.logger.info params.to_json
    req_body = JSON.parse(request.body.read)
    Rails.logger.info req_body.to_json
    msg_obj = JSON.parse(req_body['Message'])
    job_id = msg_obj['jobId']
    recording = Recording.where(transcoder_job_id: job_id).first
    if recording
      recording.transcoder_error_message = nil
      # @TODO: if existing transcoded_video_url, go find and destroy it in S3
      recording.transcoded_video_url = "http://transcoded-cdn.seeitoi.com/#{msg_obj['outputs'][0]['key']}"
      recording.save

      if recording.user.company && recording.user.company.simplified_workflow?
        SimpleVideoSummaryMailer.notify_of_project(recording).deliver
      end

    end
    render :json => {}, :status => :ok
  end

end