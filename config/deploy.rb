require 'bundler/capistrano'
require 'puma/capistrano'
require "delayed/recipes"  
# require "dotenv/capistrano"

set :rails_env, "production"

set :working_dir, 'file://.'
set :server_ip, '162.243.100.39'
set :user, 'jhbrown'

set :application, "sllapp"
set :repository, working_dir
set :local_repository, working_dir
set :scm, :git
set :deploy_via, :copy
set :use_sudo, false    
set :branch, "master"

set :deploy_to, '/opt/www/sllapp'

set :puma_config_file, 'config/puma.rb'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, server_ip                        # Your HTTP server, Apache/etc
role :app, server_ip                          # This may be the same as your `Web` server
role :db,  server_ip, :primary => true # This is where Rails migrations will run


after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

after "deploy:update", "deploy:env_symlink"

namespace :deploy do
  task :env_symlink do
    env_file = File.join(shared_path, 'system/.env')
    env_link = File.join(current_path, '.env')
    run "ln -s #{env_file} #{env_link}"
  end
end

