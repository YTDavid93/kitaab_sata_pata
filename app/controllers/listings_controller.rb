# frozen_string_literal: true

class ListingsController < ApplicationController
  include JsonResponse
  respond_to :json
  before_action :authenticate_user!
  before_action :set_listing, only: [ :show, :update, :destroy ]

  def index
    @listings = Listing.all
    render_json_success("Listings retrieved successfully", listings: @listings)
  end

  def show
    render_json_success("Listing retrieved successfully", listing: @listing)
  end

  def create
    @listing = current_user.listings.build(listing_params)
    if @listing.save
      render_json_success("Listing created successfully", listing: @listing, status_code: 201)
    else
      render_json_error("Failed to create listing", 422, @listing.errors.full_messages)
    end
  end

  def update
    if @listing.update(listing_params)
      render_json_success("Listing updated successfully", listing: @listing)
    else
      render_json_error("Failed to update listing", 422, @listing.errors.full_messages)
    end
  end

  def destroy
    @listing.destroy
    render_json_success("Listing deleted successfully")
  end

  private

  def listing_params
    params.require(:listing).permit(:title, :book_name, :author_name, :genre, :description, :listing_image)
  end

  def set_listing
    @listing = current_user.listings.find_by(id: params[:id])
    return if @listing

    render_json_error("Listing not found", 404) and return
  end
end
