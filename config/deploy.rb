
# Git changes from http://github.com/guides/deploying-with-capistrano

abort "needs capistrano 2" unless respond_to?(:namespace)
default_run_options[:pty] = true

set :application, "Website"

role :web, ""
role :app, ""
role :db,  "", :primary => true

set :deploy_to, ""

set :use_sudo, false

set :scm, :git
set :user, ""
set :repository, ""
set :branch, "master"
set :deploy_via, :remote_cache

set :port_number, "60670" 

ssh_options[:forward_agent] = true
ssh_options[:keys] = ""
ssh_options[:username] = ""
# ssh_options[:port] = 25

set :keep_releases, 5

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is no-op in Passenger"
    task t, :roles => :app do; end
  end
  after "deploy:update_code", :link_production_db, :link_log_dir
end

# database.yml task
desc "Link in the production database.yml"
task :link_production_db do
  run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

task :link_log_dir do
  run "ln -nfs #{deploy_to}/shared/log/ #{release_path}/log"
end
