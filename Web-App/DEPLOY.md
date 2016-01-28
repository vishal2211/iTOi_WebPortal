# Deployment Instructions

## Capistrano

We're using "capistrano 3" for our deployments.

We also have two environments setup, staging and production.


To deploy to either, simple run:

`bundle exec cap {environment} deploy`

where `{environment}` is either "production" or "staging".

When the script runs, it will ask you what branch you want to deploy, defaulting to "master".



## Other services

In addition to moving code onto the server, it will restart resque and run "whenever" to setup cron (see config/whenever.rb)


## SSH Certs

Make sure your itoi-prod.pem file is in `~/.ssh/` on your dev machine.  Capistrano's `config/deploy/*.rb` files look for your SSH key in this location.  It also needs to be CHMOD 0600 to properly work.