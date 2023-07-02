class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    redirect_to root_path, :flash => {alert: "Forbbiden!"} if current_user.staff?
    @review = Review.new(review_params)

    if @review.save
      redirect_back fallback_location: root_path, :flash => { notice: "Review added successfully!"}
    else
      redirect_back fallback_location: root_path, :flash => { alert:@review.errors.full_messages.join("<br/>".html_safe) }
    end
  end

  private

  def review_params
    params.require(:review).permit(:id, :title, :message, :user_id, :user_identifier, :product_id, :identifier)
  end
end