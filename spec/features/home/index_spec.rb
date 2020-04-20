# require 'rails_helper'

# feature 'home index' do
#   let(:home_index) { HomeIndex.new }

#   before do
#     @track = create(:track)
#     @track_2 = create(:track)
#   end
#   describe 'unregistered User', js: true do
#     it 'can add like rating' do
#       home_index.open
#       expect(page.current_path).to eq('/home')
#       original = page.find("#like_#{@track.id}").text.to_i
#       home_index.click_rating('#fire')
#       result = page.find("#like_#{@track.id}").text.to_i
#       image_url = page.find('#fire')['src']
#       expect(result).to eq(original + 1)
#       expect(image_url).to include('fire-active.png')
#     end

#     it 'can add indifferent rating' do
#       home_index.open
#       expect(page.current_path).to eq('/home')
#       original = page.find("#indifferent_#{@track.id}").text.to_i
#       home_index.click_rating('#sad')
#       result = page.find("#indifferent_#{@track.id}").text.to_i
#       image_url = page.find('#sad')['src']
#       expect(result).to eq(original + 1)
#       expect(image_url).to include('sad-active.png')
#     end

#     it 'can add dislike rating' do
#       home_index.open
#       expect(page.current_path).to eq('/home')
#       original = page.find("#dislike_#{@track.id}").text.to_i
#       home_index.click_rating('#unlike')
#       result = page.find("#dislike_#{@track.id}").text.to_i
#       image_url = page.find('#unlike')['src']
#       expect(result).to eq(original + 1)
#       expect(image_url).to include('unlike-active.png')
#     end
#   end
# end
