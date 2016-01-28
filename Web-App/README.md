# See iTOi Web System

## Basics

* Ruby 2.1
* Rails 4.1.x

To generate ERD:

bundle exec erd --filetype=png


http://www.techdarkside.com/getting-started-with-the-aws-elastic-transcoder-api-in-rails


Palette images:

Comment out has_many palette images on recording
bundle exec rake reap:xfer_palette_images
replace has_many palette images, remove serialize

@TODO: drop palette_images on recording