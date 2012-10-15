class RoomsController < ApplicationController
  respond_to :html

  def index
    @rooms = Room.all
  end


  def show
    # slug replaces id
    @room = Room.find_by_slug(params[:id])
  end

  def new
    @room = Room.new
  end

  def edit
    @room = Room.find_by_slug(params[:id])
  end

  def create
    @room = Room.new(params[:room])
    
    begin
      @room.session_token = OpenTokWrapper.new_session request.remote_addr
    rescue
    end

    if @room.save
      prior_rooms = cookies[:rooms] || []
      prior_rooms << @room.slug
      cookies.permanent[:rooms] = prior_rooms
      redirect_to @room #, notice: 'Room was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @room = Room.find_by_slug(params[:id])

    respond_to do |format|
      if @room.update_attributes(params[:room])
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @room = Room.find_by_slug(params[:id])
    @room.destroy

    respond_to do |format|
      format.html { redirect_to rooms_url }
      format.json { head :no_content }
    end
  end
end
