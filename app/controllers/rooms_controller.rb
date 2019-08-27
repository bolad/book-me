class RoomsController < ApplicationController

  before_action :set_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing, :photo_upload, :description, :amenities, :location, :update]

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      flash[:notice] = "Saved"
      redirect_to listing_room_path(@room)
    else
      flash[:alert] = "Something went wrong"
      render 'new'
    end
  end

  def show

  end

  def listing

  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @room.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = room_params

    #if room is active, merge the new room params with the active param with a value of true
    new_params = room_params.merge(active: true) if is_ready_room
    if @room.update(new_params)
      flash[:notice] = "saved"
    else
      flash[:alert] = "Something went wrong"
      redirect_back(fall_back_location: request.referer)

    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def is_authorized
    redirect_to root_path, alert: "You don't have permission to perform this action" unless current_user.id == @room.user_id
  end

  def is_ready_room
    !@room.active && !@room.price.blank? && !@room.listing_name.blank? && !@room.photos.blank? && !@room.address.blank?
  end

  def room_params
    #set which room attribute a user can create, update or change
    params.require(:room).permit(:home_type, :room_type, :accomodate, :bed_room,
      :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air,
      :is_heating, :is_internet, :price, :active)
  end

end
