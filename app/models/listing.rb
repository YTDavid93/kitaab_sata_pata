class Listing < ApplicationRecord
  belongs_to :user
  before_create :set_default_status
  has_many :requests, dependent: :destroy
  has_one_attached :listing_image do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 300, 200 ]
  end

  validates :user_id, :title, :book_name, :author_name, :genre, :description, presence: true
  validates :description, length: { maximum: 150 }

  validate :listing_image_validation, if: -> { listing_image.attached? }

  validates :id, uniqueness: {
    scope: :user_id,
    message: "You have already requested this book"
  }

  def image_url
    listing_image.attached? ? Rails.application.routes.url_helpers.url_for(listing_image) : nil
  end

  private

  def listing_image_validation
    if listing_image.byte_size > 5.megabytes
      errors.add(:listing_image, "should be less than 5MB")
    end

    unless listing_image.content_type.in?(%w[image/png image/jpg image/jpeg ])
      errors.add(:listing_image, "must be an image (PNG, JPG, JPEG)")
    end
  end

  def set_default_status
    self.status ||= "active"
  end
end
