# Source Inspiration:
#  http://unicorn.bogomips.org/examples/unicorn.conf.rb
#  https://github.com/redis/redis-rb/blob/master/examples/unicorn/unicorn.rb

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.
# this should be >= Number of CPUs available to Unicorn
# Number of unicorn workers to spin up per dyno
if ENV["RAILS_ENV"] == "development"
  worker_processes 4
else
  worker_processes 4
end

timeout 20         # restarts workers that hang for 20 seconds

# Prior to pre-loading the app we need to test, and ensure it will work with our redis setup.
# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
preload_app true
# This is only needed for REE, as copy on write friendly is the default state of Ruby 2.0
# http://serverfault.com/questions/354639/unicorn-and-copy-on-write-friendly
#GC.respond_to?(:copy_on_write_friendly=) and
#  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recommended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection_pool.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end

  # The following is only recommended for memory/DB-constrained
  # installations.  It is not needed if your system can house
  # twice as many worker_processes as you have configured.

  # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # Throttle the master from forking too quickly by sleeping.  Due
  # to the implementation of standard Unix signal handlers, this
  # helps (but does not completely) prevent identical, repeated signals
  # from being lost when the receiving process is busy.
  sleep 1
end

after_fork do |server, worker|
  # per-process listener ports for debugging/admin/migrations
  # addr = "127.0.0.1:#{9293 + worker.nr}"
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true)

  # the following is *required* for Rails + "preload_app true",
  if defined?(ActiveRecord::Base)
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 20 # seconds
    config['pool']              = ENV['DB_POOL'] || 25
    ActiveRecord::Base.establish_connection(config)
    Rails.logger.info('Connected to ActiveRecord')
  end

  # If you set the connection to Redis *before* forking,
  # you will cause forks to share a file descriptor.
  #
  # This causes a concurrency problem by which one fork
  # can read or write to the socket while others are
  # performing other operations.
  #
  # Most likely you'll be getting ProtocolError exceptions
  # mentioning a wrong initial byte in the reply.
  #
  # Thus we need to connect to Redis after forking the
  # worker processes.
  #
  #after_fork do |server, worker|
  #  Redis.current.quit
  #end

end
