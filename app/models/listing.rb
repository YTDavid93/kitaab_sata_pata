class Listing < ApplicationRecord
  belongs_to :user
  before_create :set_default_status
  has_many :requests, dependent: :destroy

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
