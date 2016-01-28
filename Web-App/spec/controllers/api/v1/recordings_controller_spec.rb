describe Api::V1::RecordingsController, :type => :controller do

  before(:each) do
    basic_auth_and_skip_hmac
  end

  let(:palette_images) { [FactoryGirl.build(:palette_image), FactoryGirl.build(:palette_image)] }
  let(:recording_images) { [FactoryGirl.build(:recording_image),
                           FactoryGirl.build(:recording_image, associated_string: "Rafael")] }
  let(:recording_image) { [FactoryGirl.build(:recording_image)] }

  context 'POST /api/v1/recordings' do

    context 'success' do
      it 'should create a new recording with default permission for sharing_approved(true)' do
        expect_any_instance_of(Recording).to receive(:transcode!)

        post :create, recording: {
                         title: "My Title",
                         script: "Script",
                         scroll_speed: 5,
                         duration: 15.00,
                         video_url: "http://www.seeito.com/video.mp4",
                         thumbnail_url: "http://www.seeitoi.com/thumb.png",
                         expected_length: 24,
                         recording_images: recording_images.map(&:attributes),
                         palette_images: palette_images.map(&:attributes)
                       },
                       format: :json

        expect(response.status).to eq(201)
        expect(Recording.count).to eq(1)

        expect(Recording.first.sharing_approved).to eq(true)
        
        expect(Recording.first.created_by).to eq(@user.id)
        expect(Recording.first.recording_images.count).to eq(recording_images.map(&:attributes).count)
        expect(Recording.first.palette_images.count).to eq(palette_images.map(&:attributes).count)
      end

      it 'should create a new recording with required permission for sharing videos' do
        expect_any_instance_of(Recording).to receive(:transcode!)

        company = FactoryGirl.create(:company, videos_require_approval: true)
        FactoryGirl.create(:company_user, user: @user, company: company)

        post :create, recording: {
                         title: "My Title",
                         script: "Script",
                         scroll_speed: 5,
                         duration: 15.00,
                         video_url: "http://www.seeito.com/video.mp4",
                         thumbnail_url: "http://www.seeitoi.com/thumb.png",
                         expected_length: 24,
                         recording_images: recording_images.map(&:attributes),
                         palette_images: palette_images.map(&:attributes)
                       },
                       format: :json

        expect(response.status).to eq(201)
        expect(Recording.count).to eq(1)
        
        expect(Recording.first.sharing_approved).to eq(false)
        
        expect(Recording.first.created_by).to eq(@user.id)
        expect(Recording.first.recording_images.count).to eq(recording_images.map(&:attributes).count)
        expect(Recording.first.palette_images.count).to eq(palette_images.map(&:attributes).count)
      end
    end

    context 'fail' do
      it 'should not create a new recording without all required fields' do
        post :create, recording: {title: "My Title"},format: :json

        expect(response.status).to eq(400)

        body = JSON.parse(response.body)
        expect(body['message']).to start_with("Could not create recording")
      end
    end
  end

  context 'GET /api/v1/recordings/X' do
    it 'should respond with resource' do
      @recording = FactoryGirl.create(:recording, created_by: @user.id)

      get :show, id: @recording.id

      expect(response.status).to eq(200)
      body = JSON.parse response.body
      expect(body['recording']['title']).to eq(@recording.title)
    end

    it 'should not return another users recording' do
      @recording = FactoryGirl.create(:recording)

      get :show, id: @recording.id
      expect(response.status).to eq(401)
    end
  end

  context 'PUT /api/v1/recordings/X' do

    context 'success' do
      it 'should update record created by user' do
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {title: "new title"}

        @recording.reload
        expect(@recording.title).to eq("new title")
      end

      it 'should update palette_images created by user' do
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {palette_images: palette_images.map(&:image_url)}

        @recording.reload

        expect(@recording.palette_images.map(&:image_url)).to eq(palette_images.map(&:image_url))
        expect(response.status).to eq(201)
      end

      it 'should update recording_images created by user' do
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {recording_images: recording_images.map(&:attributes)}

        @recording.reload

        expect(@recording.recording_images.map(&:image_url)).to eq(recording_images.map(&:image_url))
        expect(response.status).to eq(201)
      end
    end

    context 'update new recording_image' do
      it 'should remove deleted recording_images' do
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {recording_images: recording_images.map(&:attributes)}
        expect(response.status).to eq(201)

        put :update, id: @recording.id, recording: {recording_images: recording_image.map(&:attributes)}

        @recording.reload
        expect(response.status).to eq(201)

        expect(@recording.recording_images.map(&:image_url)).to eq(recording_image.map(&:image_url))
      end
    end

    context 'fail' do
      it 'should not allow to update recording_images without all required fields' do
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {recording_images: [{
          "associated_string": "adipiscing elit, sed",
          "image_url": "https://s3.amazonaws.com/iTOi.producer.images/B76F2F80-6B74-4EB5-A953-A734CF4EF86A.jpg",
          "start_time": 7.582,
          "end_time": 9.444,
        }]}

        expect(response.status).to eq(400)
      end

      it 'should not allow to update recording created by other user' do
        @recording = FactoryGirl.create(:recording)

        put :update, id: @recording.id, recording: {title: "new title"}
        expect(response.status).to eq(401)
      end
    end

    context 'update and transcode' do
      it 'should re-transcode if new URL is provided' do
        expect_any_instance_of(Recording).to receive(:transcode!)
        @recording = FactoryGirl.create(:recording, created_by: @user.id)

        put :update, id: @recording.id, recording: {title: "new title", video_url: "new-url"}

        @recording.reload
        expect(@recording.title).to eq("new title")
      end
    end
  end

  context 'DELETE /api/v1/recordings/x' do
    it 'should flag record as inactive' do
      @recording = FactoryGirl.create(:recording, created_by: @user.id)

      delete :destroy, id: @recording.id

      @recording.reload
      expect(response.status).to eq(200)
      expect(@recording.status).to eq(Recording::STATUS_DELETED)
    end

    it 'should not delete another users recording' do
      @recording = FactoryGirl.create(:recording)

      delete :destroy, id: @recording.id
      expect(response.status).to eq(401)
    end
  end

  context 'GET /api/v1/recordings' do
    it 'should show user recordings' do
      @recording = FactoryGirl.create(:recording, created_by: @user.id)

      get :index

      expect(response.status).to eq(200)
      body = JSON.parse response.body
      expect(body['recordings'][0]['id']).to eq(@recording.id)
    end
  end

  context 'GET /api/v1/recordings/stats' do
    it 'should show view records' do
      @recording = FactoryGirl.create(:recording_with_views, created_by: @user.id)

      get :stats

      body = JSON.parse response.body
      expect(body['stats'][0]['recording']['id']).to eq(@recording.id)
      expect(body['stats'][0]['data'][0]['count']).to eq(50)
    end
  end
end