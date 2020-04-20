class Identity < ActiveRecord::Base
  belongs_to :user
  validates :provider, :access_token, :avatar_url, presence: true, if: proc { |i| i.provider != 'prefinery' }

  scope :find_by_provider_uid, -> (provider, uid) { where(provider: provider, uid: uid) }

  def twitter_info(twitter_auth)
    { username: twitter_auth['info']['nickname'] }
  end
end
