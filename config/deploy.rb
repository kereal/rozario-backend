require 'mina/rvm'
require 'mina/git'
require 'mina/bundler'
require 'mina/rails'
require 'mina/whenever'

set :user,              'kereal'
set :application_name,  'rozshop'
set :domain,            'kereal.ru'
set :deploy_to,         "/home/#{fetch(:user)}/#{fetch(:application_name)}"
set :repository,        'git@github.com:kereal/rozario-backend.git'
set :branch,            'master'
set :keep_releases,     2
set :shared_dirs,       fetch(:shared_dirs, []).push('log', 'tmp', 'storage')
set :shared_files,      fetch(:shared_files, []).push('config/database.yml', 'config/master.key', 'db/production.sqlite3')
set :rvm_use_path,      '/usr/local/rvm/scripts/rvm'


task :remote_environment do
  invoke :'rvm:use', '3.1.2'
end

task :setup do
  command "#{fetch(:bundle_bin)} config set deployment 'true'"
  command "#{fetch(:bundle_bin)} config set path '#{fetch(:bundle_path)}'"
  command "#{fetch(:bundle_bin)} config set without '#{fetch(:bundle_withouts)}'"
  command %(mkdir -p "#{fetch(:shared_path)}/tmp/sockets")
  command %(mkdir -p "#{fetch(:shared_path)}/tmp/pids")
end

desc "Restart puma"
task :puma_restart do
  in_path fetch(:current_path) do
    command "touch #{fetch(:shared_path)}/tmp/restart.txt"
  end
end

desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    on :launch do
      invoke :puma_restart
      # invoke :'whenever:update'
    end
  end
end
