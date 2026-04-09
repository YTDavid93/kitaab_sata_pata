class Request < ApplicationRecord
  belongs_to :requester, class_name: "User"
  belongs_to :requestee, class_name: "User"
  belongs_to :listing, class_name: "Listing"
  belongs_to :offered_listing, class_name: "Listing"

  validates :requester_id, :requestee_id, :listing_id, :offered_listing_id, presence: true
  validates :status, inclusion: { in: %w[pending accepted declined], message: "%{value} is not a valid status" }
end
