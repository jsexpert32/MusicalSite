require 'image_processing/mini_magick'

class ImageUploader < Shrine
  include ImageProcessing::MiniMagick

  MAX_FILESIZE = 10.megabytes
  MIME_TYPES = %w(image/jpg image/jpeg image/png image/gif)

  plugin :direct_upload, presign: true
  plugin :store_dimensions
  plugin :remove_attachment
  plugin :versions

  Attacher.validate do
    validate_max_size shrine_class::MAX_FILESIZE
    validate_mime_type_inclusion shrine_class::MIME_TYPES
  end

  def process(io, context)
    case context[:phase]
    when :store
      thumb = resize_to_limit!(io.download, 200, 200)
      { original: io, thumb: thumb }
    end
  end
end
