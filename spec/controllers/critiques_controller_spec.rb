require 'rails_helper'

RSpec.describe CritiquesController, type: :controller do
  before(:all) do
    @user = create(:mock_user)
    @track = create(:track, user: @user)
    @comment_1 = Comment.create(user_id: @user.id, body: 'this is comment body for comment_1', commentable_id: @track.id, critique_id: 2)
    @comment_2 = Comment.create(user_id: @user.id, body: 'this is comment body for comment 2', commentable_id: @track.id, critique_id: 2)
    @track.comment_threads = [@comment_1, @comment_2]
  end
  describe '#show' do
    it 'responds correctly' do
      get :show, track_id: @track.id
      expect(response).to be_success
    end

    it 'renders critique layout' do
      get :show, track_id: @track.id
      expect(response).to render_template('layouts/critique')
    end
    context 'filter set old to new' do
      it 'assigns proper instance variables' do
        get :show, track_id: @track.id, sort: 'old'
        expect(assigns(:track)).to eq(@track)
        expect(assigns(:comments)).to eq([@comment_1, @comment_2])
      end
    end
    context 'filter new to old' do
      it 'assigns proper instance variables' do
        get :show, track_id: @track.id, sort: 'new'
        expect(assigns(:track)).to eq(@track)
        expect(assigns(:comments)).to eq([@comment_2, @comment_1])
      end
    end
  end
end
