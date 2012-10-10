class HomeController < ApplicationController
  def index
    @prior_rooms = cookies[:rooms]
    @show_ads = params[:ads] != nil
    @url = params[:url]
  end

  def login
  end
end
