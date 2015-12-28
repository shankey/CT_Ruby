module UserHelper
  def get_profile_pic(user)
    return user.profile_pictures || image_url('user-default.png')
  end
end
