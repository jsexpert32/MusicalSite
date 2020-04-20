module ApplicationHelper
  def user_avatar(user)
    if user.blank?
      image_tag 'artist-thumb.jpg'
    else
      image_tag user.avatar_url(:thumb)
    end
  end

  def critique_show_link(track)
    link_to I18n.t('count_critiques', count: track.critiques.count), critique_path(track), class: 'player__title player__title--beat'
  end

  def rating_link(track_id, rating_type, star)
    if current_user
      if current_user.ratings.where(track_id: track_id, status: Rating.statuses[star]).present?
        rating_type = "#{rating_type}-active"
      end
      link_to (image_tag "/assets/#{rating_type}.png"), cou_like_path(track_id, star), class: "on_rating image_#{track_id}", id: track_id

    else
      image_tag "/assets/#{rating_type}.png", class: 'unreg_user_on_rating', id: rating_type.to_s
    end
  end

  def extract_url(url)
    parsed = URI.parse(url)
    parsed.fragment = parsed.query = nil
    parsed.to_s
  end

  def genre_checked?(genres, check_box_genre)
    if genres
      genres.include?(check_box_genre)
    else
      false
    end
  end

  def soundbite_player(soundbite)
    sound = false
    if soundbite.data_url
      sound = "data-url='#{soundbite.data_url}'"
    elsif soundbite.data_id
      sound = "data-id='#{soundbite.data_id}'"
    end
    unless sound == false
      "<span class='soundcite' #{sound} data-start='#{soundbite.data_start}' data-end='#{soundbite.data_end}' data-plays='#{soundbite.data_plays}'> #{soundbite.title} </span>".html_safe
    end
  end

  def sort_params
    [['Newest-Oldest', 'recent'], ['Oldest-Newest', 'old']]
  end

  def spinner_loader
    '<div class="spinner-loader"></div>'
  end

  def checkbox_default(field, description_or_options = nil, options = nil, &block)
    if block_given?
      options = description_or_options if description_or_options.is_a?(Hash)
      content_for_checkbox(field, capture(&block), options)
    else
      content_for_checkbox(field, description_or_options, options)
    end
  end

  def content_for_checkbox(field, description, options)
    options ||= {}
    id = options[:id] || sanitize_to_id(field)
    content_tag(:div, class: %w(checkbox-default) << options[:class]) do
      html = check_box_tag field, options[:value] || 1, options[:checked], class: 'toggle-input', data: options[:data], id: id
      label = label_tag id, class: 'toggle-label' do
        content_tag(:span, '', class: %w(toggle-checkbox fa fa-check) << options[:checkbox_class]) <<
          content_tag(:span, description, class: %w(description-checkbox) << options[:label_class])
      end
      html << label
    end
  end

  def chart_by_period
    { 'month' => date.month,
      'week' => date.cweek }
  end
end
