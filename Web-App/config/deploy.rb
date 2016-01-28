# config valid only for Capistrano 3.1
#lock '3.3.5'

set :application, 'iTOi'
set :repo_url, 'git@github.com:SeeiTOi/Web-App.git'

# Default branch is :master, but let's ask!
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/ios public/demo}

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }


namespace :deploy do

  after :publishing, :restart

  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end

end

after "deploy:restart", "resque:restart"
require './config/boot'
