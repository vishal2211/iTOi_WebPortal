namespace :palette_images do
  task :clean  => :environment do
    puts 'Starting : Deleting all palette images which has nil image_url'
    dirty_images = PaletteImage.where(image_url: nil)
    dirty_images.destroy_all
    puts 'Done : Deleted all dirty palette images.'
  end
end