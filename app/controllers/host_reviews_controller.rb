class HostReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exists (guest_id, room_id, host_id)

    # Step 2: Check if the host already reviewed the guest in this reservation
    @reservation = Reservation.where(
      id: host_review_params[:reservation_id],
      room_id: host_review_params[:room_id],
      user_id: host_review_params[:guest_id]
    ).first

    if !reservation.nil?
      @has_reviewed = HostReview.where(
        reservation_id: host_review_params[:reservation_id],
        guest_id: host_review_params[:guest_id]
      ).first

      if @has_reviewed.nil?
        # Allow review
        @host_review = current_user.host_reviews.create(host_review_params)
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
    @host_review = Review.find(params[:id])
    @host_review.destroy

    redirect_back(fallback_location: request.referer, notice: "Review has been removed!")
  end

  private
  def host_review_params
    params.require(:host_review).permit(:comment, :star, :room_id, :reservation_id, :guest_id)
  end
end
