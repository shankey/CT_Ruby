module UserHelper
  def get_profile_pic(user)
    return user.profile_pictures || image_url('user-default.png')
  end
  
  def get_tile_image(story)
    return story.image || "/images/Gaurav_Jaipur_images/jal_mahal.jpg"
  end
end
