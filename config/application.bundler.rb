# Implement the Bundler Group Pattern:
# See: https://gist.github.com/pboling/4564780
# Load this file by replacing the if defined?(Bundler) block in config/application.rb with:
#   require File.expand_path('../application.bundler', __FILE__)

if defined?(Bundler)
  # Only load gems in the console group when the project is loaded in console mode (not in web server, rake, or test)
  Class.new Rails::Railtie do
    console do |app|
      Bundler.require(:console)
    end
  end
  groups = {
    # These groups are loaded based on current environment:
    # The arrays should contain the environments which will load each group.
    doc: %(development),
    heroku: %(production),
    non_heroku: %(development test)
  }
  # List the groups that are always loaded, followed by the ones that are selectively loaded based on environment
  # :default is all the gems that are at the root level of the Gemfile (i.e. not in a group)
  to_load = [:default, :rails4, :web_server, :data_store, :templates, :javascript, Rails.env]
  to_load.concat groups.map { |k,v| k if v.include?(Rails.env) }
  to_load.compact!
  Bundler.require(*to_load)
end
