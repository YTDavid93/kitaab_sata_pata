# frozen_string_literal: true

class BookRequestMailer < ApplicationMailer
  def new_request_email
    set_request_details

    mail(to: @requestee.email, subject: "You have received a Book Swap Request from #{@requester.name}!")
  end

  def accept_email_requestee
    set_request_details
    @offered_listing = @request.offered_listing

    mail(to: @requestee.email, subject: "Book Swap Request Confirmed - Swap with #{@requester.name}!")
  end

  def accept_email_requester
    set_request_details
    @offered_listing = @request.offered_listing

    mail(to: @requester.email, subject: "Your Book Swap Request has been accepted by #{@requestee.name}!")
  end

  def decline_email
    set_request_details

    mail(to: @requester.email, subject: "Book Swap Request Declined - #{@requestee.name} declined your request")
  end

  private

  def set_request_details
    @request = params[:request]
    @requestee = @request.requestee
    @requester = @request.requester
    @listing = @request.listing
  end
end
