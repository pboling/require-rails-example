# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

# Super Hack: https://github.com/jwhitley/requirejs-rails/issues/118#issuecomment-18007963
def ruby_rake_task(task)
  Rake::Task[task].invoke
end

require File.expand_path('../config/application', __FILE__)

RequireRailsExample::Application.load_tasks
