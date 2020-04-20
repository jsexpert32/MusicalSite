class UserMailer < BaseMailer
  default from: 'team@beatthread.com'

  def confirmation(user, token)
    @user = user
    @confirm_token = token
    email = mail to: user.email
    email.mailgun_variables = { user: @user, confirm_token: @confirm_token }
  end

  def reset_password(user)
    @user = user
    email = mail to: user.email
    email.mailgun_variables = { user: @user }
  end

  def waitlist_confirmation_email(user)
    @position = user.position
    @url      = Shortener::ShortenedUrl.generate("/waitlist/#{user.token}/activate")
    email = mail to: user.email, subject: "Spot ##{@position} on the BeatThread Beta needs to be confirmed!"
    email.mailgun_variables = { position: @position, url: @url }
  end

  def waitlist_success_email(user)
    @position = user.position
    email = mail(to: user.email, subject: "Congrats! You're ##{@position} on the BeatThread Beta!")
    email.mailgun_variables = { position: @position }
  end
end
