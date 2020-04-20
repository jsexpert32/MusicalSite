class Sound
  def initialize(redirect_uri = '')
    @redirect_uri = redirect_uri
  end

  def self.connect(token)
    Soundcloud.new(access_token: token)
  end

  def client(options = {})
    Soundcloud.new(
      client_id: ENV['SC_CLIENT_ID'],
      client_secret: ENV['SC_CLIENT_SECRET'],
      redirect_uri: @redirect_uri,
      expires_at: options[:expires_at],
      refresh_token: options[:refresh_token]
    )
  end
end
