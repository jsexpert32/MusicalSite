require 'support/base_page'

class Navigation < BasePage
  def open
    visit home_index_path
    self
  end

  def dropdown_open
    find("label[for='drop']").trigger('click')
    page.execute_script("$('.dropdown__content').css('opacity', 1).css('visibility', 'visible')")
  end

  def dropdown_close
     page.execute_script("$('.dropdown__content').attr('style', '')")
  end

  def signout
    click_link('sign out')
  end

  def open_profile
    click_link('profile')
  end
end
