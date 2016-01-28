# Load the Rails application.
require File.expand_path('../application', __FILE__)

Mime::Type.register "text/xml", :plist

# Initialize the Rails application.
Rails.application.initialize!
