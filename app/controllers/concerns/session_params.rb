module SessionParams
  def sc_identity_params
    sc_info
    { provider: 'soundcloud',
      uid: @sc_info['id'],
      access_token: @sc['access_token'],
      refresh_token: @sc['refresh_token'],
      avatar_url: @sc_info['avatar_url'],
      expires_at: @sc['expires_in'].seconds.from_now }
  end

  def sc_user_params
    sc_info
    { username: @sc_info['username'].gsub(/\s+/, ''),
      first_name: @sc_info['first_name'],
      last_name: @sc_info['last_name'],
      avatar: origin_avatar(@sc_info['avatar_url'].gsub('-large', '-original')),
      confirmed: true }
  end

  def sc_info
    @sc ||= Sound.new(auth_callbacks_url(:soundcloud)).client.exchange_token(code: params[:code])
    @sc_info ||= Sound.connect(@sc[:access_token]).get('/me')
  end

  def twitter_identity_params
    { provider: auth_hash['provider'],
      avatar_url: auth_hash['info']['image'],
      uid: auth_hash['uid'],
      access_token: auth_hash['credentials']['token'] }
  end

  def remove_empty_values(params)
    params.delete_if { |_key, value| value.blank? }
  end

  def twitter_user_params
    { username: auth_hash['info']['nickname'],
      first_name: name_split.first,
      last_name: name_split.last,
      remote_avatar_url: auth_hash['info']['image'],
      email: auth_hash['info']['email'],
      confirmed: true }
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def name_split
    auth_hash['info']['name'].split(' ')
  end

  def origin_avatar(url)
    open(url).read
    file = Tempfile.new(title, encoding: 'ascii-8bit')
    file.write(open(url).read)
    file.open
  rescue
    nil
  end
end
