# frozen_string_literal: true

class Users::ConfirmationsController < ApplicationController
  respond_to :json

  def create
    return render_missing_token if token.blank?

    user = User.find_by(confirmation_token: token)

    return render_invalid_token if user.nil?
    return render_expired_token if user.confirmation_token_expired?

    if user.confirm
      render_success
    else
      render_confirmation_failure(user)
    end
  end

  private

  def token
    params[:token]
  end

  def render_missing_token
    render json: {
      status: { code: 422, message: "Confirmation token is required" }
    }, status: :unprocessable_entity
  end

  def render_invalid_token
    render json: {
      status: { code: 404, message: "Invalid confirmation token" }
    }, status: :not_found
  end

  def render_expired_token
    render json: {
      status: { code: 422, message: "Confirmation token has expired" }
    }, status: :unprocessable_entity
  end

  def render_success
    render json: {
      status: {
        code: 200,
        message: "Email confirmed successfully"
      }
    }, status: :ok
  end

  def render_confirmation_failure(user)
    render json: {
      status: { code: 422, message: "Failed to confirm email", errors: user.errors.full_messages }
    }, status: :unprocessable_entity
  end
end
