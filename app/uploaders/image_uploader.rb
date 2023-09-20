class ImageUploader < Shrine
    Attacher.validate do
      validate_mime_type %w[image/jpeg image/png image/webp]
      validate_max_size  1*2048*2048
    end
end