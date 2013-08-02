class WelcomeController < ApplicationController

  # GET /
  def index
    render template: 'layouts/application', layout: false # Just render the layout.
  end

end
