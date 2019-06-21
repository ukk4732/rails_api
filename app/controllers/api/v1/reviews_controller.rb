class Api::V1::ReviewsController < ApplicationController
  before_action :load_book, only: [:index]
  before_action :load_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    reviews = @book.reviews
    reviews_serializer = parse_json reviews
    json_response "Review index successfully", true, {reviews: reviews_serializer}, :ok
  end

  def show
    review_serializer = parse_json @review
    json_response "Review show successfully", true, {review: review_serializer}, :ok
  end

  def create
    review = Review.new review_params
    review.user_id = current_user.id
    review.book_id = params[:book_id]
    if review.save
      review_serializer = parse_json review
      json_response "Review created successfully", true, {review: review_serializer}, :ok
    else
      json_response review.errors, false, {}, :unproccessable_entity
    end
  end

  def update
    if correct_user @review.user
      if @review.update review_params
        review_serializer = parse_json @review
        json_response "Review updated successfully", true, {review: review_serializer}, :ok
      else
        json_response "Review updated fails", false, {}, :unproccessable_entity
      end
    else
      json_response "You don not have permision to do that", false, {}, :unauthorized
    end
  end

  def destroy
    if correct_user @review.user
      if @review.destroy
        json_response "Review deleted successfully", true, {}, :ok
      else
        json_response "Review deleted fails", false, {}, :unproccessable_entity
      end
    else
      json_response "You don not have permision to do that", false, {}, :unauthorized
    end
  end

  private

  def load_book
    @book = Book.find_by id: params[:book_id]
    unless @book 
      json_response "Can not find a book", false, {}, :not_found
    end
  end

  def load_review
    @review = Review.find_by id: params[:id]
    unless @review
      json_response "Can not find a review", false, {}, :not_found
    end
  end

  def review_params
    params.require(:review).permit(:id, :title, :content_rating, :recommend_rating, :book_id)
  end
    
end