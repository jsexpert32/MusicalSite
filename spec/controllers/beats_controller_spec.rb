require 'rails_helper'

RSpec.describe BeatsController, type: :controller do
  # before(:each) do
  #   @user = create(:mock_user)
  #   @user_2 = create(:mock_user)
  #   @user_3 = create(:mock_user)
  #   @user_2 = create(:mock_user)
  #   @user_3 = create(:mock_user)
  #   @track_1 = create(:track, user_id: @user.id, title: 'track_1')
  #   @track_2 = create(:track, user_id: @user.id, title: 'track_2')
  #   @track_3 = create(:track, user_id: @user.id, title: 'track_3')
  #   @track_4 = create(:track, user_id: @user.id, title: 'track_4')
  #   @track_5 = create(:track, user_id: @user.id, title: 'track_5')
  #   @no_ratings_track = create(:track, user_id: @user.id, title: 'no_ratings')

  #   @genre_1 = create(:genre, name: 'hip-hop')
  #   @genre_2 = create(:genre, name: 'east-coast')
  #   @genre_3 = create(:genre, name: 'experimental')

  #   @subgenre_1 = create(:subgenre, name: 'Alternative')
  #   @subgenre_2 = create(:subgenre, name: 'Boom Bap')
  #   @subgenre_3 = create(:subgenre, name: 'East Coast')

  #   create(:rating, user_id: @user.id, track_id: @track_1.id, status: 0)
  #   create(:rating, user_id: @user.id, track_id: @track_2.id, status: 0)
  #   create(:rating, user_id: @user.id, track_id: @track_3.id, status: 0)
  #   create(:rating, user_id: @user.id, track_id: @track_4.id, status: 0)
  #   create(:rating, user_id: @user.id, track_id: @track_5.id, status: 0)
  #   create(:rating, user_id: @user_2.id, track_id: @track_1.id, status: 1)
  #   create(:rating, user_id: @user_2.id, track_id: @track_2.id, status: 1)
  #   create(:rating, user_id: @user_2.id, track_id: @track_3.id, status: 1)
  #   create(:rating, user_id: @user_2.id, track_id: @track_4.id, status: 1)
  #   create(:rating, user_id: @user_2.id, track_id: @track_5.id, status: 1)
  #   create(:rating, user_id: @user_3.id, track_id: @track_1.id, status: 2)
  #   create(:rating, user_id: @user_3.id, track_id: @track_2.id, status: 2)
  #   create(:rating, user_id: @user_3.id, track_id: @track_3.id, status: 2)
  #   create(:rating, user_id: @user_3.id, track_id: @track_4.id, status: 2)
  #   create(:rating, user_id: @user_3.id, track_id: @track_5.id, status: 2)

  #   @track_1.genres << @genre_1
  #   @track_2.genres << @genre_1
  #   @track_3.genres << @genre_2
  #   @track_4.genres << @genre_3
  #   @track_5.genres << @genre_3

  #   @track_1.subgenres << @subgenre_1
  #   @track_2.subgenres << @subgenre_1
  #   @track_3.subgenres << @subgenre_2
  #   @track_4.subgenres << @subgenre_3
  #   @track_5.subgenres << @subgenre_3

  #   create(:track_charted, track_id: @track_1.id)
  #   create(:track_charted, track_id: @track_1.id, week: 5)
  #   create(:track_charted, track_id: @track_2.id, year: 2)
  #   create(:track_charted, track_id: @track_3.id, month: 5)
  # end

  # def likes_filter_data
  #   @track_1.update!(like_count: 10, dislike_count: 3)
  #   @track_2.update!(like_count: 15, dislike_count: 2)
  #   @track_3.update(like_count: 11, indifferent_count: 15)
  # end

  # def indifference_filter_data
  #   @track_1.update!(indifferent_count: 10, dislike_count: 3)
  #   @track_2.update!(indifferent_count: 15, dislike_count: 2)
  #   @track_3.update(indifferent_count: 11, like_count: 15)
  # end

  # def dislikes_filter_data
  #   @track_1.update!(dislike_count: 10, indifferent_count: 3)
  #   @track_2.update!(dislike_count: 15, indifferent_count: 2)
  #   @track_3.update!(dislike_count: 11, like_count: 15)
  # end

  # def dislikes_with_likes_filter_data
  #   @track_1.update!(dislike_count: 15, like_count: 8, indifferent_count: 4)
  #   @track_2.update!(dislike_count: 14, like_count: 10, indifferent_count: 4)
  #   @track_3.update!(dislike_count: 15, like_count: 10, indifferent_count: 100)
  #   @track_4.update!(dislike_count: 13, like_count: 9, indifferent_count: 2)
  # end

  # def likes_with_indifference_filter_data
  #   @track_1.update!(like_count: 15, indifferent_count: 8, dislike_count: 4)
  #   @track_2.update!(like_count: 14, indifferent_count: 10, dislike_count: 4)
  #   @track_3.update!(like_count: 15, indifferent_count: 10, dislike_count: 100)
  #   @track_4.update!(like_count: 13, indifferent_count: 9, dislike_count: 2)
  # end

  # def likes_with_indifference_with_dislikes_filter_data
  #   @track_1.update!(like_count: 20, indifferent_count: 15, dislike_count: 4)
  #   @track_2.update!(like_count: 20, indifferent_count: 18, dislike_count: 5)
  #   @track_3.update!(like_count: 15, indifferent_count: 30, dislike_count: 4)
  #   @track_4.update!(like_count: 15, indifferent_count: 30, dislike_count: 6)
  #   @track_5.update!(like_count: 30, indifferent_count: 30, dislike_count: 30)
  # end

  # def indifference_with_dislikes_filter_data
  #   @track_1.update!(indifferent_count: 15, dislike_count: 8, like_count: 4)
  #   @track_2.update!(indifferent_count: 14, dislike_count: 10, like_count: 4)
  #   @track_3.update!(indifferent_count: 15, dislike_count: 10, like_count: 100)
  #   @track_4.update!(indifferent_count: 13, dislike_count: 9, like_count: 2)
  # end

  # describe '#index' do
  #   context 'no filter' do
  #     it 'responds correctly' do
  #       get :index
  #       expect(response).to be_success
  #     end
  #   end
  #   context 'all beats filter' do
  #     it 'assigns proper instance variables' do
  #       get :index, filters: { all_beats: 'on', sorted_by: 'all' }
  #       expect(assigns(:tracks)).to include(@no_ratings_track, @track_1, @track_2, @track_3, @track_4, @track_5)
  #       expect(assigns(:page)).to eq(20)
  #     end
  #   end
  #   context 'likes ratings filter' do
  #     it 'assigns proper instance variables' do
  #       likes_filter_data
  #       get :index, filters: { ratings: ['like'] }
  #       expect(assigns(:tracks)).to eq([@track_2, @track_3, @track_1, @track_4, @track_5])
  #       expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #     end
  #     context 'with indifference' do
  #       it 'assigns proper instance variables' do
  #         likes_with_indifference_filter_data
  #         get :index, filters:  { ratings: %w(like indifferent) }
  #         expect(assigns(:tracks)).to eq([@track_3, @track_1, @track_2, @track_4, @track_5])
  #         expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #       end
  #       context 'with dislikes' do
  #         it 'assigns proper instance variables' do
  #           likes_with_indifference_with_dislikes_filter_data
  #           get :index, filters:  { ratings: %w(like indifferent dislike) }
  #           expect(assigns(:tracks)).to eq([@track_5, @track_2, @track_1, @track_4, @track_3])
  #           expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #         end
  #       end
  #     end
  #   end
  #   context 'indifference ratings filter' do
  #     it 'assigns proper instance variables' do
  #       indifference_filter_data
  #       get :index, filters: { ratings: ['indifferent'] }
  #       expect(assigns(:tracks)).to eq([@track_2, @track_3, @track_1, @track_4, @track_5])
  #       expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #     end
  #     context 'with dislikes' do
  #       it 'assigns proper instance variables' do
  #         indifference_with_dislikes_filter_data
  #         get :index, filters:  { ratings: %w(indifferent dislike) }
  #         expect(assigns(:tracks)).to eq([@track_3, @track_1, @track_2, @track_4, @track_5])
  #         expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #       end
  #     end
  #   end
  #   context 'dislikes ratings filter' do
  #     it 'assigns proper instance variables' do
  #       dislikes_filter_data
  #       get :index, filters: { ratings: ['dislike'] }
  #       expect(assigns(:tracks)).to eq([@track_2, @track_3, @track_1, @track_4, @track_5])
  #       expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #     end
  #     context 'with likes' do
  #       it 'assigns proper instance variables' do
  #         dislikes_with_likes_filter_data
  #         get :index, filters:  { ratings: %w(like dislike) }
  #         expect(assigns(:tracks)).to eq([@track_3, @track_2, @track_4, @track_1, @track_5])
  #         expect(assigns(:tracks)).to_not include(@no_ratings_track)
  #       end
  #     end
  #   end
  #   context 'charted' do
  #     it 'assigns proper instance variables' do
  #       get :index, filters: { charted: '1' }
  #       expect(assigns(:tracks)).to include(@track_2, @track_3, @track_1)
  #       expect(assigns(:tracks)).to_not include(@track_4, @track_5)
  #     end
  #   end
  #   context 'last 24 hrs' do
  #     it 'assigns proper instance variables' do
  #       @track_1.update!(created_at: 1.week.ago)
  #       @track_2.update!(created_at: 1.year.ago)
  #       @track_3.update!(created_at: 1.month.ago)
  #       @track_4.update!(created_at: 1.day.ago)
  #       get :index, filters: { all_beats: 'on', sorted_by: 'last 24hrs' }
  #       expect(assigns(:tracks)).to include(@track_5, @track_4)
  #       expect(assigns(:tracks)).to_not include(@track_2, @track_3)
  #     end
  #   end
  #   context 'last week' do
  #     it 'assigns proper instance variables' do
  #       @track_1.update!(created_at: 1.week.ago)
  #       @track_2.update!(created_at: 1.year.ago)
  #       @track_3.update!(created_at: 1.month.ago)
  #       @track_4.update!(created_at: 1.day.ago)
  #       get :index, filters: { all_beats: 'on', sorted_by: 'week' }
  #       expect(assigns(:tracks)).to include(@track_4, @track_5)
  #       expect(assigns(:tracks)).to_not include(@track_2, @track_3)
  #     end
  #   end
  #   context 'last month' do
  #     it 'assigns proper instance variables' do
  #       @track_1.update!(created_at: 1.week.ago)
  #       @track_2.update!(created_at: 1.year.ago)
  #       @track_3.update!(created_at: 1.month.ago)
  #       @track_4.update!(created_at: 1.day.ago)
  #       get :index, filters: { all_beats: 'on', sorted_by: 'month' }
  #       expect(assigns(:tracks)).to include(@track_1, @track_4, @track_5)
  #       expect(assigns(:tracks)).to_not include(@track_2, @track_3)
  #     end
  #   end
  #   context 'last year' do
  #     it 'assigns proper instance variables' do
  #       @track_1.update!(created_at: Time.now.ago(60_000_000)) # over a year ago
  #       @track_2.update!(created_at: 1.year.ago)
  #       @track_3.update!(created_at: 1.month.ago)
  #       @track_4.update!(created_at: 1.day.ago)
  #       get :index, filters: { all_beats: 'on', sorted_by: 'year' }
  #       expect(assigns(:tracks)).to include(@track_4, @track_5, @track_3)
  #       expect(assigns(:tracks)).to_not include(@track_1)
  #     end
  #   end
  #   context 'subgenres' do
  #     it 'assigns proper instance variables' do
  #       get :index, filters: { subgenre: [@subgenre_1.id, @subgenre_2.id] }
  #       expect(assigns(:tracks)).to include(@track_1, @track_2, @track_3)
  #       expect(assigns(:tracks)).to_not include(@track_4, @track_5)
  #     end
  #   end
  # end
end
