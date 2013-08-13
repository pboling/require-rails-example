source 'https://rubygems.org'

ruby '2.0.0'

group :rails4 do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.0.0'
  # Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
  gem 'turbolinks'
end

group :web_server do
  # The Webserver
  gem 'unicorn'
end

group :data_store do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
end

group :templates do
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 4.0.0'
  # This is the UI Framework that is full of bad-assery
  gem 'zurb-foundation' # github: 'zurb/foundation'
  # a template engine
  gem 'tilt', '>= 1.3.6', require: false # => Heroku all of a sudden can't find 1.3.5
  # View Template Language
  gem 'slim', '>= 1.3.7'
  # Makes the default generator view template slim
  gem 'slim-rails', '>= 1.1.1'
  # Markdown Parser (for copy)
  gem 'redcarpet', '>= 2.2.2', require: false
end

group :javascript do
  # Use CoffeeScript for .js.coffee assets and views
  gem 'coffee-rails', '~> 4.0.0'
  # Use jquery as the JavaScript library
  gem 'jquery-rails' # we use a CDN for jquery, but this configures all the other stuff
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder', '~> 1.2'
  # Enable the AMD design pattern for Javascript modules and integrate into the Asset Pipeline ========>
  gem 'requirejs-rails', github: 'acquaintable/requirejs-rails' #path: '/Users/pboling//Documents/src/acq/requirejs-rails' #
  # moved out of assets group due to config/initializers/handlebars_assets.rb
  gem 'handlebars_assets', github: 'acquaintable/handlebars_assets' #, ref: '5b22bf80f20eb606595bbeb848ba42ba050ee0be' # '~> 0.12.0' #
  # Use Uglifier as compressor for JavaScript assets
  # Haven't figured out a way to use a JavaScript compressor while also using JS from CDNs with RequireJS.
  #gem 'uglifier', '>= 1.3.0', require: false
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :heroku do
  # Compass can compile our SCSS
  gem 'compass-rails' # github: 'ai/compass-rails', branch: 'rails4'
  # This sets up a proxy on deploy which will hold connections until the app is booted and can respond.
  gem 'heroku-forward'
end

group :non_heroku do
  # Ensures that .env will be loaded into the environment even when outside foreman (e.g. rake, rails console)
  gem 'dotenv-rails', '~> 0.6.0', require: false
end

group :development do
  # Fast booting local dev webserver
  gem 'puma', require: false
  # Local dev webserver, mimics Heroku deployed environment
  gem 'foreman', require: false
end
