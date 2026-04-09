class Listing < ApplicationRecord
  belongs_to :user
  before_create :set_default_status
  has_many :requests, dependent: :destroy
  has_one_attached :listing_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 300, 200 ]
  end

  validates :user_id, :title, :book_name, :author_name, :genre, :description, presence: true
  validates :description, length: { maximum: 150 }

  validates :id, uniqueness: {
    scope: :user_id,
    message: "You have already requested this book"
  }

  private

  def set_default_status
    self.status ||= "active"
  end
end
