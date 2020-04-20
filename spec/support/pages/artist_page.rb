require 'support/base_page'

class ArtistPage < BasePage
  def open(user)
    visit artist_track_list_path(user)
    self
  end

  def click_edit_track(track_id)
    find("div[data-id='#{track_id}'] a.editable").click
  end

  def change_track(attributes = [])
    attributes.each do |attr, value|
      fill_in "track[#{attr}]", with: value
    end
    click_button 'finish'
  end

  def delete_track
    click_link('delete')
  end

  def cancel_edit_track
    click_link('cancel')
  end
end
