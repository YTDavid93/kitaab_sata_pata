# frozen_string_literal: true

module JsonResponse
  extend ActiveSupport::Concern

  def render_json_success(message, data = nil, status_code = 200)
    response = {
      success: true,
      message: message
    }
    response = response.merge(data: data) if data.present?
    render json: response, status: status_code
  end

  def render_json_error(message, status_code, errors = nil)
    response = {
      success: false,
      message: message
    }
    response = response.merge(errors: errors) if errors.present?
    render json: response, status: status_code
  end
end
