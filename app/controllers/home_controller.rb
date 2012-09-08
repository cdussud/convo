class HomeController < ApplicationController
  def index
    @prior_rooms = cookies[:rooms]
    @show_ads = params[:ads] != nil
  end
end
