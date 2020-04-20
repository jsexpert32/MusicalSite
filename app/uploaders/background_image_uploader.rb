class BackgroundImageUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
