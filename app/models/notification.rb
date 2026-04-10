class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }
  scope :read, -> { where(read: true) }

  def broadcast_to_user
    ActionCable.server.broadcast(
      "notifications_#{user_id}",
      serialized_notification
    )
  end

  private

  def serialized_notification
    NotificationSerializer.new(self).serializable_hash
  end
end
