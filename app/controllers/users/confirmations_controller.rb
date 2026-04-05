# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  respond_to :json

  def create
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource && resource.errors.empty?
      render json: { status: { message: "Email confirmed successfully" } }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          message: "Failed to confirm email",
          errors: resource ? resource.errors.full_messages : []
        }
      }, status: :unprocessable_entity
    end
  end
end
