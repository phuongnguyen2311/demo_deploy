# config valid for current version and patch releases of Capistrano
lock '~> 3.17.3'

set :application, 'devops_basic'
set :repo_url, 'git@github.com:phuongnguyen2311/demo_deploy.git'
set :user, 'ubuntu'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :airbrussh.
set :format, :airbrussh

set :pty,             true
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/#{fetch(:application)}/current"
# set :linked_files, %w[config/secrets.yml]
# set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads]
set :keep_releases, 5

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc 'seed database'
  task :seed do
    on roles(:db) do |_host|
      within "#{release_path}" do
        execute :rake, 'db:seed'
      end
    end
  end

  after 'deploy:publishing', 'deploy:restart'
end

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, -> { "#{shared_path}/tmp/pids/puma.state" }
set :puma_pid, -> { "#{shared_path}/tmp/pids/puma.pid" }
set :puma_bind, -> { "unix://#{shared_path}/tmp/sockets/puma.sock" }
set :puma_conf, -> { "#{shared_path}/puma.rb" }
set :puma_access_log, -> { "#{shared_path}/log/puma_access.log" }
set :puma_error_log, -> { "#{shared_path}/log/puma_error.log" }
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'staging'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false
