class AddColsToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :max_video_length_seconds, :int, :null => false, :default => 0
    add_column :plans, :total_video_space_minutes, :int, :null => false, :default => 0
    add_column :plans, :video_filters, :int, :null => false, :default => 0
    add_column :plans, :can_download, :boolean, :null => false, :default => 0
    add_column :plans, :video_quality, :int, :null => false, :default => 0
    add_column :plans, :youtube_share, :boolean, :null => false, :default => 0
    add_column :plans, :custom_watermark, :boolean, :null => false, :default => 0
    add_column :plans, :custom_header_graphic, :boolean, :null => false, :default => 0
    add_column :plans, :custom_footer_graphic, :boolean, :null => false, :default => 0
    add_column :plans, :video_analytics, :boolean, :null => false, :default => 0
    remove_column :plans, :permissions
  end
end
