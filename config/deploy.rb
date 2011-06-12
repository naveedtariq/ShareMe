require 'bundler/capistrano'

set :application, "shareme"
set :repository,  "git@github.com:pronix/central_sms_informer.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "bfile.adenin.ru"                          # Your HTTP server, Apache/etc
role :app, "bfile.adenin.ru"                          # This may be the same as your `Web` server
role :db,  "bfile.adenin.ru", :primary => true # This is where Rails migrations will run
role :db,  "bfile.adenin.ru"

set :deploy_to, "/var/www/#{application}"

set :rails_env, "production"

set :deploy_via, :remote_cache
set :use_sudo, false
set :ssh_options, {:forward_agent => true, :port => 6022 }
set :branch, "master"
set :user, "root"


set :spinner, false
set :deploy_via, :remote_cache
set :keep_releases, 3

set :bundle_flags,       "--quiet"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end


after  "deploy:update",  "deploy:migrate"
after  "deploy:migrate", "deploy:chown_apache"
before "deploy:migrate", "deploy:symlink_database"
after "deploy:update", "deploy:cleanup"




namespace :deploy do

  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with passenger"
    task t, :roles => :app do ; end
  end

  task :symlink_database do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml "
    run "ln -nfs #{shared_path}/db/production.sqlite3 #{latest_release}/db/production.sqlite3 "
    run "ln -nfs #{shared_path}/db/schema.rb #{latest_release}/db/schema.rb "
  end

  task :chown_apache do
    run "chown -R nginx:nginx #{current_path}/"
  end



end

# Build the SASS Stylesheets
before "deploy:restart" do
  run "cd #{current_path} && rake RAILS_ENV=#{rails_env} sass:build"
end
