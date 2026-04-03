# frozen_string_literal: true

class Users::ConfirmationsController < ApplicationController
  respond_to :json

  def create
    token = params[:token]

    if token.blank?
      return render json: {
        status: { code: 422, message: "Confirmation token is required" }
      }, status: :unprocessable_entity
    end

    user = User.find_by(confirmation_token: token)

    if user.nil?
      return render json: {
        status: { code: 404, message: "Invalid confirmation token" }
      }, status: :not_found
    end

    if user.confirmation_token_expired?
      return render json: {
        status: { code: 422, message: "Confirmation token has expired" }
      }, status: :unprocessable_entity
    end

    if user.confirm
      render json: {
        status: {
          code: 200,
          message: "Email confirmed successfully"
        }
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "Failed to confirm email", errors: user.errors.full_messages }
      }, status: :unprocessable_entity
    end
  end
end
