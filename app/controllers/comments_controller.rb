class CommentsController < ApplicationController

  def create
    @track = Track.find(params[:track_id])
    @comment = @track.comment_threads.build(permit_params)

    if @comment.save

      @notification = Notification.create(recipient: @track.user, actor: current_user, action: 'commented', notifiable: @track)

      if @comment.body.include?('@')
        comment = @comment.body.split('@')
        comment.shift
        users = []
        comment.each do |user|
          user = user.split(' ').first
          users << user
        end
        users.each do |user|
          user[0] = ''
          user = User.find_by_username(user)
          @notification = Notification.create(recipient: user, actor: current_user, action: 'replied', notifiable: @comment)
        end
      end

      Tracker.track({ critique_author: current_user.name, critiques_on_track: @track.critiques.count }, 'Create Critique')
      respond_to do |format|
        format.js
        format.json {render json: { comment: @comment}}
      end
    else
      respond_to do |format|
        format.js
        format.json { render json: { errors: @comment.errors.as_json }, status: 420 }
      end
    end
  end

  def destroy
    current_user.comments.find(params[:id]).destroy
    redirect_to track_path(params[:track_id])
  end

  def permit_params
    params[:comment][:user_id] = current_user.id
    params.require(:comment).permit(:body, :user_id)
  end
end
