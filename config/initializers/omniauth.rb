Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, "IGEpNQSbzPokonHlFQzAdGxOI", "jNhr5ITUsX9NQlpKtT6GtQb0Gtj33z6OBZtcUSioJr5IhK7F5E"
  {
      :secure_image_url => 'true',
      :image_size => 'original',
      :authorize_params => {
        :force_login => 'true',
        :lang => 'pt'
      }
    }
end