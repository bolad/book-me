class PagesController < ApplicationController
  def home
    @rooms = Room.where(active: true).limit(3)
  end

  def search
   # STEP 1
   #Check if user entered a valid location
   if params[:search].present? && params[:search].strip != ""
     #Store the location user enters in a session
     session[:loc_search] = params[:search]
   end

   # STEP 2
   #If specific location is known, display all rooms near location
   if session[:loc_search] && session[:loc_search] != ""
     @rooms_address = Room.where(active: true).near(session[:loc_search], 5, order: 'distance')
   else
     #else display all active rooms
     @rooms_address = Room.where(active: true).all
   end

   # STEP 3
   @search = @rooms_address.ransack(params[:q])
   @rooms = @search.result

   @arrRooms = @rooms.to_a

   # STEP 4
   # Check if any reservation for the room the user user searched for falls within
   # the timeframe specified. If we find any such reservation, it means the room is
   # not available and we need to remove it from the search results
   if (params[:start_date] && params[:end_date] && !params[:start_date].empty? && !params[:end_date].empty?)

     start_date = Date.parse(params[:start_date])
     end_date = Date.parse(params[:end_date])

     @rooms.each do |room|

       not_available = room.reservations.where(
       "(? <= start_date AND start_date <= ?)
       OR (? <= end_date AND end_date <= ?)
       OR (start_date < ? AND ? < end_date)",
       start_date, end_date,
       start_date, end_date,
       start_date, end_date
       ).limit(1)

       if not_available.length > 0
         @arrRooms.delete(room)
       end
     end
   end
 end
end
