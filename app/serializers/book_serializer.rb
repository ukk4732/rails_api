class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :author, :image 
  # :average_content_rating, :average_recommend_rating
  has_many :reviews

  def average_content_rating
    object.reviews.count == 0 ? 0 : object.reviews.average(:content_rating).round(1)
  end

  def average_recommend_rating
    object.reviews.count == 0 ? 0 : object.reviews.average(:recommend_rating).round(1)
  end

end
