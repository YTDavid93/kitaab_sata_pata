# frozen_string_literal: true

class RequestsController < ApplicationController
  include JsonResponse
  respond_to :json
  before_action :authenticate_user!
  before_action :set_request, only: [ :accept, :decline ]
  before_action :authorize_requestee!, only: [ :accept, :decline ]

  def create
    @request = current_user.requester_requests.build(request_params)

    # check if existing request exists
    existing_request = check_existing_request(request_params[:listing_id], request_params[:requestee_id])

    if existing_request
      render_json_error("You have already made a request for this listing to this user", 422) and return
    end

    if @request.save
      # Send email asynchronously after creating the request
      BookRequestMailer.with(request: @request).new_request_email.deliver_later
      render_json_success("Request created successfully", request: @request, status_code: 201)
    else
      render_json_error("Failed to create request", 422, @request.errors.full_messages)
    end
  end

  def accept
    if @request.update(status: "accepted")
      # send email to both requester and requestee, so that they can coordinate the swap
      BookRequestMailer.with(request: @request).accept_email_requestee.deliver_later
      BookRequestMailer.with(request: @request).accept_email_requester.deliver_later
      render_json_success("Request accepted successfully", request: @request)
    else
      render_json_error("Failed to accept request", 422, @request.errors.full_messages)
    end
  end

  def decline
    if @request.update(status: "declined")
      BookRequestMailer.with(request: @request).decline_email.deliver_later
      render_json_success("Request declined successfully", request: @request)
    else
      render_json_error("Failed to decline request", 422, @request.errors.full_messages)
    end
  end

  private

  def request_params
    params.require(:request).permit(:listing_id, :requestee_id, :offered_listing_id)
  end

  def set_request
    @request = Request.find_by(id: params[:id])
    return if @request

    render_json_error("Request not found", 404, "No request exists with the provided id") and return
  end

  def authorize_requestee!
    unless @request.requestee_id == current_user.id
      render_json_error("Unauthorized", 403, "You can only accept or decline requests made to you") and return
    end
  end

  def check_existing_request(listing_id, requestee_id)
    Request.find_by(listing_id: listing_id, requestee_id: requestee_id, requester_id: current_user.id)
  end
end
