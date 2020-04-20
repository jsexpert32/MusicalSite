class User < ActiveRecord::Base
  include VerifierConcern

  mount_base64_uploader :avatar, AvatarUploader
  mount_base64_uploader :background_image, BackgroundImageUploader
  acts_as_messageable

  enum roles: [:user, :admin]

  has_many :comments,   dependent: :destroy
  has_many :tracks,     dependent: :destroy
  has_many :ratings,    dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id
  has_many :track_comments, -> { where(commentable_type: 'Track') }, class_name: Comment
  has_many :commented_tracks, -> { uniq }, through: :track_comments, source: :commentable, source_type: Track

  validates :email,     uniqueness: true, presence: true
  validates :email,     format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
  validates :username,  uniqueness: true, length: { minimum: 4 }, presence: true
  validates :username,  format: { with: /\A^[a-zA-Z][-a-zA-Z0-9_.]+\Z/ }
  validates :first_name, :last_name, :city, :country, presence: true
  validates :password,  presence: true, if: -> { password_digest.blank? }
  validates :password,  length: { minimum: 8 }, if: -> { password.present? }

  has_secure_password

  recommends :tracks

  before_like      :increase_rating
  before_undislike :increase_rating
  before_unlike    :decrease_rating
  before_dislike   :decrease_rating
  before_create :generate_auth_token

  after_save :confirm_email
  after_create :set_default_avatar

  def increase_rating(track)
    rating = track.rating + 1
    update_rating(track, rating)
  end

  def decrease_rating(track)
    rating = track.rating - 1
    update_rating(track, rating)
  end

  def update_rating(track, rating)
    total_shares = track.permalink ? SocialShares.total(track.permalink) : 0

    rating += track.social_shares >= total_shares ? track.social_shares - total_shares : total_shares

    track.update(rating: rating, social_shares: total_shares)
  end

  def self.fetch_identity(identity_params, user_params)
    identity = Identity.find_by_provider_uid(identity_params[:provider], identity_params[:uid]).first
    user = identity&.user
    if user
      user.update(user_params)
      identity.update(identity_params)
      return user
    end
    user = new(user_params)
    user.save(validate: false)
    user.identities.create(identity_params)
    user
  end

  def confirm!
    update_column(:confirmed, true)
  end

  def name
    "#{first_name} #{last_name}"
  end

  def mailboxer_email(_object)
    nil
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save(validate: false)
    UserMailer.reset_password(self).deliver_later
  end

  def generate_token(column)
    loop do
      self[column] = SecureRandom.urlsafe_base64
      break unless User.exists?(column => self[column])
    end
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

  def tester_id
    identity = identities.find_by(provider: 'prefinery')
    return raise StandardError, 'No Prefinery identity found.' unless identity
    identity.uid
  end

  def current_tester?
    identities.where(provider: 'prefinery').present? && identities.find_by(provider: 'prefinery').uid.present?
  end

  def position
    identities.find_by(provider: 'prefinery') ? identities.find_by(provider: 'prefinery').access_token : '2500'
  end

  def missing_password?
    password_digest.blank? || %i(password password_confirmation).any? { |a| errors.include?(a) }
  end

  def check_uniq_email
    valid?
    self.email = nil if errors.include?(:email)
  end

  def artist_info
    [username, city, country].join(', ')
  end

  def track_count
    tracks.count
  end

  private

  def confirm_email
    if changed.include?('email')
      token = verifier.generate(id: id)
      update_column(:confirmed, false)
      UserMailer.confirmation(self, token).deliver_later
    end
  end

  def set_default_avatar
    unless self[:avatar].present?
      assign_attributes(avatar: data_default_avatar)
      save(validate: false)
    end
  end

  def data_default_avatar
    regex = %r{\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)\Z}
    data_uri_parts = Identicon.data_url_for(username, 300).match(regex)
    title = username || 'user_avatar'
    file = Tempfile.new(title, encoding: 'ascii-8bit')
    file.write(Base64.decode64(data_uri_parts[2]))
    ActionDispatch::Http::UploadedFile.new(tempfile: file.open, filename: title, type: data_uri_parts[1])
  end
end
