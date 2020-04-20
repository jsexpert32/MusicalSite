module BeatFilters
  extend ActiveSupport::Concern

  private


#   creates a query ordering tracks by rating_types
#   if only likes filter is checked then
#       will load all tracks with "like" ratings in descending order
#   if likes and indifferents filters are both checked
#       will load all tracks with "likes" and "indifferents" prioritizing 'likes' descending and then "dislikes" descending
#        example:
# track 1 - 99 flames, 90 indifferents
# track 2 - 99 flames, 80 indifferents
# track 3 - 96 flames, 90 indifferents
# track 4 - 90 flames, 99 indifferents
  def rating_order(rating_types)
    return "#{rating_types[0]}_count DESC" if rating_types.count == 1
    query_string = "#{rating_types[0]}_count DESC"
    rating_types.shift
    rating_types.map { |type| query_string << ", #{type}_count DESC" }
    query_string
  end


  def filters
    subgenre     = params[:filters][:subgenre] || Subgenre.pluck(:id)
    all_beats    = params[:filters][:all_beats]
    charted      = params[:filters][:charted]
    rating_types = params[:filters][:ratings]
    time_range   = params[:filters][:sorted_by]
    query        = Track.includes(:subgenres, :ratings).where('subgenres.id' => subgenre)

    enum_rating_types = rating_types.map {|t| Rating.statuses[t]} if rating_types.present?
    if all_beats.present?
      @tracks = Track.time_ago(time_range).page(params[:page]).per(@page)

    elsif charted.present?
      charted_tracks = Track.all_charted_tracks
      @tracks  =  if enum_rating_types.present?
                    charted_tracks.includes(:ratings)
                    .where(id: query.pluck(:id), 'ratings.status' => enum_rating_types)
                    .time_ago(time_range).page(params[:page]).per(@page)
                    .order(rating_order(rating_types))
                  else
                    charted_tracks.time_ago(time_range).page(params[:page]).per(@page)
                  end
    else
      @tracks = if enum_rating_types.present?
                  query.where( 'ratings.status' => enum_rating_types )
                  .time_ago(time_range).page(params[:page]).per(@page)
                  .order(rating_order(rating_types))
                else
                  query.time_ago(time_range).page(params[:page]).per(@page)
                end
    end
  end
end
