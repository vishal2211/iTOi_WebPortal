namespace :reap do

  task :remove_deleted_projects => :environment do

    Recording.where(status: Recording::STATUS_DELETED).where("deleted_at < ?", 30.days.ago).each do |recording|
      recording.permanently_delete!
    end

  end

  task :xfer_palette_images => :environment do
    Recording.all.each do |recording|
      next unless recording.palette_images
      next if recording.palette_images == "null"
      recording.palette_images.each do |pi|
        PaletteImage.create(recording: recording, image_url: pi)
      end
    end
  end

end