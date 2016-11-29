class StoryPicture < ActiveRecord::Base
  has_attached_file :picture,
                    styles: { medium:  "1000x1000", medium_reduced:  "1000x1000"},
                    convert_options: { medium_reduced:  "-quality 50"},
                    processors: [:thumbnail]

  # # Validate content type
  validates_attachment_content_type :picture, content_type: /\Aimage/
  # # Validate filename
  validates_attachment_file_name :picture, matches: [/png\z/, /jpe?g\z/]
  # # Explicitly do not validate

end
