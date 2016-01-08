module UserHelper
  def get_profile_pic(user)
    return user.profile_pictures || image_url('user-default.png')
  end
  
  def get_tile_image(story)
    return story.image || "/images/Gaurav_Jaipur_images/jal_mahal.jpg"
  end
  
  def get_user_tile_image(user)
    return user.user_title_picture || "/images/Gaurav_Jaipur_images/jal_mahal.jpg"
  end
  
  def verify_story_user (ts, user)
    if(ts.user_id == user.id)
      return true
    else
      return false
    end
  end
  
end
