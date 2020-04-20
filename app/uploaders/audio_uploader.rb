class AudioUploader < Shrine
  MAX_FILESIZE = 50.megabytes

  MIME_TYPES = %w(audio/mpeg audio/mp3 audio/ogg audio/x-aiff audio/flac application/octetstream).freeze # validate type
  plugin :direct_upload, max_size: MAX_FILESIZE, presign: true
  plugin :remote_url,    max_size: MAX_FILESIZE
  plugin :hooks

  Attacher.validate do
    validate_max_size shrine_class::MAX_FILESIZE
    validate_mime_type_inclusion shrine_class::MIME_TYPES
  end

  plugin :included do |name|
    UPLOAD_PATHS = HashWithIndifferentAccess.new unless defined?(UPLOAD_PATHS)
    UPLOAD_PATHS[name] = "/upload/audio/cache/#{IS_LOCAL ? name : 'presign'}".freeze
    define_singleton_method("#{name}_upload_path") { UPLOAD_PATHS[name] }
    delegate "#{name}_upload_path", to: :class
  end

  # applies "peaks" to Track.waveform
  plugin :included do |name|
    after_save do
      if send("#{name}_data_changed?") && send(name) && send(name).storage_key == "cache"
        self.update_columns(waveform: send(name).metadata["peaks"])
      end
    end
  end

  # calculates peaks from audio file and attaches as an array to the files metadata
  def around_upload(io, context)
    @super_audio = super
    if context[:phase] == :cache
      path  = io.respond_to?(:tempfile) ? io.tempfile.path : io.path
      audio = FFMPEG::Movie.new(path)
      wav   = Tempfile.new(['forwaveform', '.wav'])

      eval(validate_shrine(audio))
      audio.transcode(wav.path)

      peaks         = []
      length        = 60
      info          = WaveFile::Reader.info(wav.path)
      sample_size   = info.sample_frame_count / length

      WaveFile::Reader.new(wav.path, WaveFile::Format.new(:mono, :float, 44_100)) do |reader|
        reader.each_buffer(sample_size) do |buffer|
          intermediary = []
          steps = buffer.samples.length / 10
          (0..9).each do |step|
            intermediary.push(buffer.samples[step * steps].round(2))
          end
          peaks.push(intermediary.max)
          peaks.push(intermediary.min)
        end

        @super_audio.metadata.update("peaks" => peaks)
      end
    end
  end

  def validate_shrine(audio)
    return 'return' unless audio.audio_codec.present?
    return (MIME_TYPES.grep(/audio.audio_codec/).any? || audio.size < MAX_FILESIZE) ? '' : 'return'
  end
end
