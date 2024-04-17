server '54.191.133.183', user: 'ubuntu', roles: %w[app web db]
set :rvm_ruby_version, '2.7.6'
set :default_env, {
  'IS_DEV_SERVER' => 'true'
}
set :stage, :production
set :rails_env, :production
set :branch, 'master'
set :bundle_flags, '--no-deployment'
set :no_deploytags, true

set :ssh_options, {
  keys: %w[~/.ssh/ruby-k06.pem],
  forward_agent: true,
  port: 22
}
