require 'support/base_page'


class HomeIndex < BasePage
  def open
  	visit '/home'
  	self
  end

  def click_rating(icon_id)
    page.find(icon_id).click
  end
end