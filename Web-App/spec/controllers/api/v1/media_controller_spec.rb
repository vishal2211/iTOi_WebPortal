describe Api::V1::MediaController, :type => :controller do

  before(:each) do
    basic_auth_and_skip_hmac(true)
  end

  context 'POST /api/v1/media' do

    context 'success conditions' do
      it 'creates a new media item' do
        post :create, format: :json, media_item: {name: "Media Item", media_url: "http://google.com", company_id: 1}
        
        expect(response.status).to eq(201)
        expect(MediaItem.count).to eq(1)
        expect(json['media']).to eq({"id"=>1, "name"=>"Media Item", "media_url"=>"http://google.com", "company_id"=>1})
      end
    end

    context 'failure conditions' do
      it 'rejects incomplete request' do
        post :create, format: :json, media_item: {name: "Media Item"}
        
        expect(response.status).to eq(400)
        expect(MediaItem.count).to eq(0)
        expect(json['message']).to start_with("Could not create recording:")
      end
    end

  end

  context 'GET /api/v1/media' do
    it 'lists items' do
      @item = create(:media_item, company: @user.company)

      get :index, format: :json
      
      expect(json['media'][0]['id']).to eq(@item.id)
    end
  end

  context 'DELETE /api/v1/media' do
    it 'should remove item' do
      @item = create(:media_item, company: @user.company)

      delete :destroy, id: @item.id, format: :json

      expect(MediaItem.count).to eq(0)
      expect(response.status).to eq(200)
      expect(json).to eq({})
    end
  end

end