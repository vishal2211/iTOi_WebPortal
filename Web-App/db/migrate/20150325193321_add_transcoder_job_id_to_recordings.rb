class AddTranscoderJobIdToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :transcoder_job_id, :string
  end
end
