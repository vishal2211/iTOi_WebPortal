
# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'manage.seeitoi.com', user: 'ubuntu', roles: %w{web app db resque_worker resque_scheduler}

set :worker, {"*" => 2}
set :resque_environment_task, true
set :resque_log_file, "log/resque.log"
set :rails_env, "staging"
set :deploy_to, '/srv/deploy/itoi-staging'

set :ssh_options, {
   user: 'ubuntu',
   keys: %w(~/.ssh/itoi.pem),
   forward_agent: false,
   auth_methods: %w(publickey)
}
