## This file is used by Rack-based servers to start the application.
#
#require ::File.expand_path('../config/environment',  __FILE__)
#run Rails.application
#
require 'rubygems'
require 'bundler'

# Fail-safe in case we need to disable the proxy (as we would locally with foreman)
if ENV['DISABLE_FORWARD_PROXY']

  eval File.read(::File.expand_path('../example.ru', __FILE__))

else

  $stdout.sync = true
  Bundler.require(:rack)

  port = (ARGV.first || ENV['PORT'] || 3000).to_i
  env = ENV['RACK_ENV'] || 'development'

  require 'em-proxy'
  require 'logger'
  require 'heroku-forward'
  require 'heroku/forward/backends/unicorn'

  #
  # Setup a reverse proxy for faster Heroku boot and future load-balancing.
  #

  application = File.expand_path('../example.ru', __FILE__)
  config_file = File.expand_path('../config/unicorn.rb', __FILE__)
  backend = Heroku::Forward::Backends::Unicorn.new(application: application, env: env, config_file: config_file)
  proxy = Heroku::Forward::Proxy::Server.new(backend, host: '0.0.0.0', port: port)
  proxy.forward!#(delay: 15)

end
