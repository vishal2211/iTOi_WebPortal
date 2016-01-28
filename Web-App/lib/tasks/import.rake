# set recording_images.recording to allow null, null default
# allow null created_by, expected_length

namespace :import do
  task :users => :environment do
    user_data = JSON.parse(File.read("#{Rails.root}/data/_User.json"))
    user_data['results'].each do |user|
      next unless user['email']
      local_u = User.where(email: user['email']).first_or_initialize
      local_u.parse_id = user['objectId']
      local_u.encrypted_password = user['bcryptPassword']
      local_u.invitation_accepted_at = Time.now
      local_u.save!({validate: false})
    end
  end

  task :video_images => :environment do
    image_data = JSON.parse(File.read("#{Rails.root}/data/PVVideoImage.json"))
    image_data['results'].each do |image|
      local_img = RecordingImage.where(parse_id: image['objectId']).first_or_initialize
      local_img.associated_string = image['associatedString']
      next unless image['image'] && image['image']['url']
      local_img.image_url = image['image']['url']
      local_img.start_time = image['startTime']
      local_img.end_time = image['endTime']
      local_img.scroll_height = image['imagesScrollHeight']
      local_img.scroll_y_value = image['imagesScrollYValue']
      local_img.save
    end
  end

  task :videos => :environment do
    vid_data = JSON.parse(File.read("#{Rails.root}/data/PVProject.json"))
    vid_data['results'].each do |vid|
      rec = Recording.where(parse_id: vid['objectId']).first_or_initialize
      rec.parse_video_uuid = vid['UUID']
      rec.font_size = vid['fontSize'] || 40
      rec.title = vid['projectTitle'] || ''
      rec.script = vid['script']
      rec.scroll_speed = vid['scrollSpeed']
      rec.video_url = vid['remoteVideo']
      rec.save
      if vid['images']
        vid['images'].each do |vid_image|
          RecordingImage.where(parse_id: vid_image['objectId']).each do |img|
            img.recording_id = rec
            img.save
          end
        end
      end
    end
  end

  task :user_videos => :environment do
    user_data = JSON.parse(File.read("#{Rails.root}/data/_User.json"))
    user_data['results'].each do |user|
      local_u = User.where(parse_id: user['objectId']).first
      next unless local_u

      if user['projects']
        user['projects'].each do |proj|
          rec = Recording.where(parse_id: proj['objectId']).first
          next unless rec
          rec.created_by = local_u.id
          rec.save
        end
      end
    end
  end

  task :video_length => :environment do
    vid_data = JSON.parse(File.read("#{Rails.root}/data/PVCloudVideo.json"))
    vid_data['results'].each do |vid|
      video = Recording.where(video_url: vid['videoURL']).first
      if video
        video.expected_length = vid['lengthInSeconds']
        video.save
      end
    end
  end

  task :all => :environment do
    Rake::Task["import:users"].invoke
    Rake::Task["import:video_images"].invoke
    Rake::Task["import:videos"].invoke
    Rake::Task["import:user_videos"].invoke
    Rake::Task["import:video_length"].invoke
  end
end