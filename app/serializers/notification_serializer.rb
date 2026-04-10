class NotificationSerializer
  include JSONAPI::Serializer

  attributes :message, :read, :user_id, :created_at, :updated_at
end
