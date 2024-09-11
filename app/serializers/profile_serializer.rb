class ProfileSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :name, :followers_count, :followees_count
  attribute :avatar_url, if: :has_avatar?
  def followers_count
    object.followers.count
  end

  def followees_count
    object.followees.count
  end

  def avatar_url
    rails_blob_url(object.avatar,
                   host: Rails.application.config.action_mailer.default_url_options[:host],
                   port: Rails.application.config.action_mailer.default_url_options[:port]
    )
  end

  def has_avatar?
    object.avatar.attached?
  end
end
