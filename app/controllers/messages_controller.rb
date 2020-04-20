class MessagesController < ApplicationController
  before_action :set_conversation

  def typing
    render nothing: true
  end

  def create
    receipt = current_user.reply_to_conversation(@conversation, params[:body])

    data = { date: receipt.message.created_at.strftime('%H:%M').to_s, sender_name: receipt.message.sender.name.to_s, body: receipt.message.body.to_s }

    (@conversation.recipients - [current_user]).each do |recipient|
      notification = Notification.create(recipient: recipient, actor: current_user, action: 'sent a message', notifiable: @conversation)
      data = { text: "#{notification.actor.name} #{notification.action} in #{notification.notifiable.class.to_s.underscore.humanize.downcase}" }
    end

    render js: "$('form')[0].reset()"
  end

  private

  def set_conversation
    @conversation = current_user.mailbox.conversations.find(params[:conversation_id])
    @user_ids = []
    @conversation.recipients.each { |recipient| @user_ids << recipient.id.to_s }
  end
end
