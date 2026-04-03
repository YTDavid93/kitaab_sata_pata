# frozen_string_literal: true

require "test_helper"

class Users::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  test "returns 422 when token is missing" do
    post "/confirm-email", params: {}

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 422, json["status"]["code"]
    assert_equal "Confirmation token is required", json["status"]["message"]
  end

  test "returns 404 when token is invalid" do
    post "/confirm-email", params: { token: "nonexistent_token" }

    assert_response :not_found
    json = JSON.parse(response.body)
    assert_equal 404, json["status"]["code"]
    assert_equal "Invalid confirmation token", json["status"]["message"]
  end

  test "returns 422 when token is expired" do
    post "/confirm-email", params: { token: users(:expired_token_user).confirmation_token }

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_equal 422, json["status"]["code"]
    assert_equal "Confirmation token has expired", json["status"]["message"]
  end

  test "returns 200 on successful confirmation" do
    post "/confirm-email", params: { token: users(:unconfirmed_user).confirmation_token }

    assert_response :ok
    json = JSON.parse(response.body)
    assert_equal 200, json["status"]["code"]
    assert_equal "Email confirmed successfully", json["status"]["message"]
  end
end
