# frozen_string_literal: true

class NotificationsController < ApplicationController
  include JsonResponse
  respond_to :json
  before_action :authenticate_user!
  before_action :set_notification, only: [ :mark_as_read ]

  def index
    @notifications = current_user.notifications.order(created_at: :desc)
    render_json_success("Notifications retrieved successfully", notifications: @notifications)
  end

  def mark_as_read
    if @notification.update(read: true)
      render_json_success("Notification marked as read", notification: @notification)
    else
      render_json_error("Failed to mark notification as read", 422, @notification.errors.full_messages)
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find_by(id: params[:id])
    return if @notification

    render_json_error("Notification not found", 404) and return
  end
end
