class HomeController < ApplicationController
  def index
    @prior_rooms = cookies[:rooms]
  end
end
