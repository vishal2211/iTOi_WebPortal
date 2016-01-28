class AddTranscoderErrorMessageToRecordings < ActiveRecord::Migration
  def change
    add_column :recordings, :transcoder_error_message, :string
  end
end
