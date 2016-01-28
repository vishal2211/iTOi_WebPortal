describe Api::V1::CallbacksController, :type => :controller do

  context 'POST /api/v1/callbacks/success' do
    context 'when a success SNS notification is received after transcoding video' do
      it 'should update the transcoded url for video' do
        user = create(:user)
        recording = create(:recording, transcoder_job_id: "1427312474388-xhw7w8", created_by: user.id)

        post :success, File.read("spec/fixtures/sns_success.json")

        recording.reload
        expect(recording.transcoded_video_url).to eq("http://transcoded-cdn.seeitoi.com/trans-1-1427312474.mp4")
      end

      it 'should send eamil to the user' do
        user = create(:user)
        recording = create(:recording, transcoder_job_id: "1427312474388-xhw7w8", created_by: user.id)
        company = create(:company, simplified_workflow: true)
        create(:company_user, user: user, company: company)
        ActionMailer::Base.deliveries = []

        post :success, File.read("spec/fixtures/sns_success.json")

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        expect(ActionMailer::Base.deliveries.first.to).to eq([recording.user.email])
        expect(ActionMailer::Base.deliveries.first.from).to eq(["no-reply@seeitoi.com"])
        expect(ActionMailer::Base.deliveries.first.subject).to eq("Your See iTOi Video")
      end
    end
  end

  context 'POST /api/v1/callbacks/failure' do
    context 'when a failure SNS notification is received after transcoding video' do
      it 'should update the error message field' do
        user = create(:user)
        recording = create(:recording, transcoder_job_id: "1427311493823-u37u65", created_by: user.id)

        post :fail, File.read("spec/fixtures/sns_failure.json")

        recording.reload
        expect(recording.transcoder_error_message).to eq("3002 67e9e2fb-25ab-4410-aaa2-d8d58e7ecff1: \
The specified object could not be saved in the specified bucket because an object by that name already exists: \
bucket=itoi-output, key=trans-1.mp4.")
      end
    end
  end

end