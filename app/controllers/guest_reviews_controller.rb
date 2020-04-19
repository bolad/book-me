class GuestReviewsController < ApplicationController
  def create
    # Step 1: Check if the reservation exists (host_id, room_id, host_id)

    # Step 2: Check if the host already reviewed the guest in this reservation
    @reservation = Reservation.where(
      id: guest_review_params[:reservation_id],
      room_id: guest_review_params[:room_id],
      user_id: guest_review_params[:guest_id]
    ).first

    if !@reservation.nil? && @reservation.room.user.id == guest_review_params[:host_id].to_i
      @has_reviewed = GuestReview.where(
        reservation_id: guest_review_params[:reservation_id],
        host_id: guest_review_params[:host_id]
      ).first

      if @has_reviewed.nil?
        # Allow review
        @guest_review = current_user.guest_reviews.create(guest_review_params)
        flash[:success] = "Your review has been submitted"
      else
        flash[:success] = "You have already reviewed this reservation"
      end
    else
      flash[:alert] = "This reservation was not found"
    end
    }

    # redirect back to current page
    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @guest_review = Review.find(params[:id])
    @guest_review.destroy

    redirect_back(fallback_location: request.referer, notice: "Review has been removed!")
  end

  private
  def guest_review_params
    params.require(:guest_review).permit(:comment, :star, :room_id, :reservation_id, :host_id)
  end
end
